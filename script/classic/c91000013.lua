--Timegazer Magician
local s,id=GetID()

function s.initial_effect(c)
    --Protect Pendulum Zone cards once per turn
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_PZONE,0)
    e1:SetCountLimit(1)
    e1:SetValue(s.indval)
    c:RegisterEffect(e1)
end

function s.indval(e,re,r,rp)
    return (r&REASON_EFFECT)~=0
        and rp~=e:GetHandlerPlayer()
end
