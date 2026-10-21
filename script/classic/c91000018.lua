--Crystal Bond
local s,id=GetID()

function s.initial_effect(c)
    --Activate 1 per turn
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
    e1:SetCost(s.cost)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
end

--Crystal Beast monster
function s.thfilter(c)
    return c:IsSetCard(0x1034)
        and c:IsMonster()
        and c:IsAbleToHand()
end

--Different name Crystal Beast
function s.stfilter(c,code)
    return c:IsSetCard(0x1034)
        and c:IsMonster()
        and not c:IsCode(code)
        and not c:IsForbidden()
end

--Check for two different Crystal Beasts
function s.pairfilter(c,tp)
    return s.thfilter(c)
        and Duel.IsExistingMatchingCard(
            s.stfilter,tp,LOCATION_DECK,0,1,c,c:GetCode()
        )
end

--Discard 1 card
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.IsExistingMatchingCard(
            Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil
        )
    end

    Duel.DiscardHand(
        tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD
    )
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
            and Duel.IsExistingMatchingCard(
                s.pairfilter,tp,LOCATION_DECK,0,1,nil,tp
            )
    end
    Duel.SetOperationInfo(
        0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK
    )
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then
        return
    end

    --Add Crystal Beast to hand
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(
        tp,s.pairfilter,tp,LOCATION_DECK,0,1,1,nil,tp
    )
    local tc=g:GetFirst()
    if not tc then return end

    local code=tc:GetCode()

    if Duel.SendtoHand(tc,nil,REASON_EFFECT)==0 then
        return
    end
    Duel.ConfirmCards(1-tp,tc)

    --Place a different Crystal Beast as Continuous Spell
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then
        return
    end

    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local sg=Duel.SelectMatchingCard(
        tp,s.stfilter,tp,LOCATION_DECK,0,1,1,nil,code
    )
    local sc=sg:GetFirst()

    if sc then
        Duel.MoveToField(
            sc,tp,tp,LOCATION_SZONE,POS_FACEUP,true
        )

        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_TYPE)
        e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        sc:RegisterEffect(e1)
    end
end
