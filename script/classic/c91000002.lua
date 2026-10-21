--Performapal Odd-Eyes Unicorn
local s,id=GetID()

function s.initial_effect(c)
    --Gain 500 ATK on Normal or Special Summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCountLimit(1,id)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)

    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
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
    local g=Duel.SelectTarget(
        tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil
    )
    Duel.SetOperationInfo(
        0,CATEGORY_ATKCHANGE,g,1,tp,500
    )
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if not tc or not tc:IsRelateToEffect(e)
        or not tc:IsFaceup() then
        return
    end

    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(500)
    e1:SetReset(
        RESET_EVENT+RESETS_STANDARD
        +RESET_PHASE+PHASE_END
    )
    tc:RegisterEffect(e1)
end
