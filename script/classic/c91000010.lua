--Odd-Eyes Persona Dragon
local s,id=GetID()

function s.initial_effect(c)
    --Negate effects of an Extra Deck monster
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_DISABLE)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
end

function s.filter(c)
    return c:IsFaceup()
        and c:IsSummonLocation(LOCATION_EXTRA)
        and not c:IsDisabled()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then
        return chkc:IsLocation(LOCATION_MZONE)
            and s.filter(chkc)
    end
    if chk==0 then
        return Duel.IsExistingTarget(
            s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil
        )
    end

    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local g=Duel.SelectTarget(
        tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil
    )
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if not tc or not tc:IsRelateToEffect(e)
        or not tc:IsFaceup() then
        return
    end

    --Negate monster effects
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_DISABLE)
    e1:SetReset(
        RESET_EVENT+RESETS_STANDARD
        +RESET_PHASE+PHASE_END
    )
    tc:RegisterEffect(e1)

    local e2=e1:Clone()
    e2:SetCode(EFFECT_DISABLE_EFFECT)
    tc:RegisterEffect(e2)
end
