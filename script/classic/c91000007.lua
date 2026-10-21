--Odd-Eyes Gravity Dragon
local s,id=GetID()

function s.initial_effect(c)
    c:EnableReviveLimit()

    --Ritual Summon with Odd-Eyes Advent
    --Ritual procedure is handled by the Ritual Spell

    --Return opponent's Spells/Traps to hand
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
end

function s.filter(c)
    return c:IsSpellTrap() and c:IsAbleToHand()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(
        s.filter,tp,0,LOCATION_ONFIELD,nil
    )
    if chk==0 then
        return #g>0
    end
    Duel.SetOperationInfo(
        0,CATEGORY_TOHAND,g,#g,0,0
    )
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(
        s.filter,tp,0,LOCATION_ONFIELD,nil
    )
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
    end
end
