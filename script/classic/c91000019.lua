--Ancient City - Rainbow Ruins
local s,id=GetID()

function s.initial_effect(c)
    --Activate Field Spell
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)

    --1+: Halve all battle damage (continuous)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetRange(LOCATION_FZONE)
    e1:SetTargetRange(1,0)
    e1:SetCondition(s.damcon)
    e1:SetValue(HALF_DAMAGE)
    c:RegisterEffect(e1)

    --2+: Send Crystal Beast to GY, destroy 1 card
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(s.con2)
    e2:SetCost(s.descost)
    e2:SetTarget(s.destg)
    e2:SetOperation(s.desop)
    c:RegisterEffect(e2)

    --3+: Cannot be destroyed by card effects
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_FZONE)
    e3:SetCondition(s.con3)
    e3:SetValue(1)
    c:RegisterEffect(e3)

    --4+: Draw 1 card
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,2))
    e4:SetCategory(CATEGORY_DRAW)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_FZONE)
    e4:SetCountLimit(1)
    e4:SetCondition(s.con4)
    e4:SetTarget(s.drawtg)
    e4:SetOperation(s.drawop)
    c:RegisterEffect(e4)

    --5+: Special Summon or search Rainbow Dragon
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id,3))
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_FZONE)
    e5:SetCountLimit(1,id)
    e5:SetCondition(s.con5)
    e5:SetTarget(s.lv5tg)
    e5:SetOperation(s.lv5op)
    c:RegisterEffect(e5)
end

--Count face-up Crystal Beast cards in S/T Zone
function s.cbfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x1034)
end

function s.count(tp)
    return Duel.GetMatchingGroupCount(
        s.cbfilter,tp,LOCATION_SZONE,0,nil
    )
end

--Conditions
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
    return s.count(tp)>=1
end

function s.con2(e,tp)
    return s.count(tp)>=2
end

function s.con3(e,tp)
    return s.count(tp)>=3
end

function s.con4(e,tp)
    return s.count(tp)>=4
end

function s.con5(e,tp)
    return s.count(tp)>=5
end

--2+: Send Crystal Beast monster as cost
function s.costfilter(c)
    return c:IsSetCard(0x1034)
        and c:IsMonster()
        and c:IsAbleToGraveAsCost()
end

function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.IsExistingMatchingCard(
            s.costfilter,tp,LOCATION_MZONE,0,1,nil
        )
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(
        tp,s.costfilter,tp,LOCATION_MZONE,0,1,1,nil
    )
    Duel.SendtoGrave(g,REASON_COST)
end

--2+: Destroy a card
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.IsExistingMatchingCard(
            Card.IsDestructable,tp,
            LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil
        )
    end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
    if s.count(tp)<2 then return end

    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(
        tp,Card.IsDestructable,tp,
        LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil
    )
    if #g>0 then
        Duel.Destroy(g,REASON_EFFECT)
    end
end

--4+: Draw 1 card
function s.drawtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.IsPlayerCanDraw(tp,1)
    end
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function s.drawop(e,tp,eg,ep,ev,re,r,rp)
    if s.count(tp)>=4 then
        Duel.Draw(tp,1,REASON_EFFECT)
    end
end

--5+: Crystal Beast in S/T Zone
function s.spfilter(c,e,tp)
    return c:IsFaceup()
        and c:IsSetCard(0x1034)
        and c:IsMonster()
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

--5+: Rainbow Dragon in Deck
function s.thfilter(c)
    return c:IsCode(79856792)
        and c:IsAbleToHand()
end

function s.lv5tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0
            and Duel.IsExistingMatchingCard(
                s.spfilter,tp,LOCATION_SZONE,0,1,nil,e,tp
            ))
            or Duel.IsExistingMatchingCard(
                s.thfilter,tp,LOCATION_DECK,0,1,nil
            )
    end
end

function s.lv5op(e,tp,eg,ep,ev,re,r,rp)
    if s.count(tp)<5 then return end

    local can_sp=
        Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(
            s.spfilter,tp,LOCATION_SZONE,0,1,nil,e,tp
        )

    local can_th=Duel.IsExistingMatchingCard(
        s.thfilter,tp,LOCATION_DECK,0,1,nil
    )

    if not can_sp and not can_th then return end

    local option=0

    if can_sp and can_th then
        option=Duel.SelectOption(
            tp,aux.Stringid(id,3),aux.Stringid(id,4)
        )
    elseif can_th then
        option=1
    end

    if option==0 then
        --Special Summon Crystal Beast
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(
            tp,s.spfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp
        )
        if #g>0 then
            Duel.SpecialSummon(
                g,0,tp,tp,false,false,POS_FACEUP
            )
        end
    else
        --Add Rainbow Dragon
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(
            tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil
        )
        if #g>0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        end
    end
end
