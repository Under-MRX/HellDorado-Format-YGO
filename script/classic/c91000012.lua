--Stargazer Magician
local s,id=GetID()

function s.initial_effect(c)
    --Special Summon a monster with the same name
    --as a returned Pendulum Monster
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_TO_HAND)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCondition(s.condition)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
    if Duel.IsDamageStep() then return false end
    if ep==tp or not re or not re:IsActiveType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER) then
        return false
    end

    if #eg~=1 then return false end

    local tc=eg:GetFirst()
    return tc:IsType(TYPE_PENDULUM)
        and tc:IsPreviousControler(tp)
        and tc:IsPreviousLocation(LOCATION_MZONE)
        and tc~=e:GetHandler()
        and tc:IsReason(REASON_EFFECT)
        and tc:IsLocation(LOCATION_HAND)
end

function s.spfilter(c,e,tp,code)
    return c:IsCode(code)
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local tc=eg:GetFirst()
    local code=tc and tc:GetCode()

    if chk==0 then
        return code
            and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
            and Duel.IsExistingMatchingCard(
                s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,code
            )
    end

    e:SetLabel(code)
    Duel.SetOperationInfo(
        0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND
    )
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
        return
    end

    local code=e:GetLabel()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(
        tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,code
    )

    if #g>0 then
        Duel.SpecialSummon(
            g,0,tp,tp,false,false,POS_FACEUP
        )
    end
end
