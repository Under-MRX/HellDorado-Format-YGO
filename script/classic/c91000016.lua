--ガガガクラーク
--Gagaga Clerk
local s,id=GetID()
function s.initial_effect(c)
    --Invocation Spéciale (Une fois par tour)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH) -- Limite à une fois par tour
    e1:SetCondition(s.spcon)
    c:RegisterEffect(e1)
end

s.listed_series={SET_GAGAGA}

-- Filtre : Un autre monstre "Gagaga" face recto sur le terrain
function s.filter(c)
    return c:IsFaceup() and c:IsSetCard(SET_GAGAGA) and c:GetCode()~=id
end

-- Condition d'Invocation
function s.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
        Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil)
end