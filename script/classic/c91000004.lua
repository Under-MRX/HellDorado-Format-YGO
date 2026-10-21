--Odd-Eyes Mirage Dragon
local s,id=GetID()

function s.initial_effect(c)
    --Protect an Odd-Eyes monster
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.condition)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
end

function s.pfilter(c)
    return c:IsSetCard(0x99)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(
        s.pfilter,tp,LOCATION_PZONE,0,1,nil
    )
end

function s.filter(c)
    return c:IsFaceup()
        and c:IsSetCard(0x99)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then
        return chkc:IsLocation(LOCATION_MZONE)
            and chkc:IsControler(tp)
            and s.filter(chkc)
    end
    if chk==0 then
        return Duel.IsExistingTarget(
            s.filter,tp,LOCATION_MZONE,0,1,nil
        )
    end

    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(
        tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil
    )
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if not tc or not tc:IsRelateToEffect(e)
        or not tc:IsFaceup() then
        return
    end

    --Protect once from battle destruction
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
    e1:SetCountLimit(1)
    e1:SetValue(s.indval)
    e1:SetReset(
        RESET_EVENT+RESETS_STANDARD
        +RESET_PHASE+PHASE_END
    )
    tc:RegisterEffect(e1)
end

function s.indval(e,re,r,rp)
    return (r&REASON_BATTLE)~=0
        or (r&REASON_EFFECT)~=0
end
