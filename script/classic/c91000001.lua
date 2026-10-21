--Performapal Odd-Eyes Valet
local s,id=GetID()

function s.initial_effect(c)
    --Send monster to GY and change Level
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_LVCHANGE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
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
    return (c:IsSetCard(0x9f) or c:IsSetCard(0x99))
        and not c:IsCode(id)
        and c:IsMonster()
        and c:HasLevel()
        and c:IsAbleToGrave()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.IsExistingMatchingCard(
            s.filter,tp,LOCATION_DECK,0,1,nil
        )
    end
    Duel.SetOperationInfo(
        0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK
    )
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(
        tp,s.filter,tp,LOCATION_DECK,0,1,1,nil
    )
    local tc=g:GetFirst()
    if not tc then return end

    local lv=tc:GetLevel()
    if Duel.SendtoGrave(tc,REASON_EFFECT)>0
        and tc:IsLocation(LOCATION_GRAVE)
        and c:IsFaceup() and c:IsRelateToEffect(e) then

        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_LEVEL)
        e1:SetValue(lv)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
    end
end
