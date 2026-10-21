--Spiral Flame Strike
local s,id=GetID()

function s.initial_effect(c)
    --Destroy 1 card on the field
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCondition(s.condition)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
end

function s.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x99)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(
        s.cfilter,tp,LOCATION_ONFIELD,0,1,nil
    )
end

function s.filter(c)
    return c:IsOnField()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then
        return chkc:IsOnField()
    end
    if chk==0 then
        return Duel.IsExistingTarget(
            s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil
        )
    end

    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(
        tp,s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil
    )
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end
