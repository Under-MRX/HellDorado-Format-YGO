--Performapal Ladyange
local s,id=GetID()

function s.initial_effect(c)
    --Discard 2 monsters to draw 2 cards
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,id)
    e1:SetCost(s.cost)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
end

function s.cfilter(c)
    return c:IsSetCard(0x9f)
        and c:IsMonster()
        and not c:IsCode(id)
        and c:IsDiscardable()
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then
        return c:IsDiscardable()
            and Duel.IsExistingMatchingCard(
                s.cfilter,tp,LOCATION_HAND,0,1,c
            )
    end

    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
    local g=Duel.SelectMatchingCard(
        tp,s.cfilter,tp,LOCATION_HAND,0,1,1,c
    )
    g:AddCard(c)
    Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.IsPlayerCanDraw(tp,2)
    end
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Draw(tp,2,REASON_EFFECT)
end
