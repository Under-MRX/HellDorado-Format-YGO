--古代の採掘機
--Ancient Gear Drill (Modified to set only Ancient Gear Spells)
local s,id=GetID()
function s.initial_effect(c)
    --Activation
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SET)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(s.condition)
    e1:SetCost(s.cost)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
end

s.listed_series={SET_ANCIENT_GEAR}

-- Condition : Contrôler un monstre "Ancient Gear" face recto
function s.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsSetCard,SET_ANCIENT_GEAR),tp,LOCATION_MZONE,0,1,nil)
end

-- Coût : Défausser 1 carte
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST|REASON_DISCARD)
end

-- Filtre : Uniquement les Magies "Ancient Gear" qui peuvent être posées
function s.setfilter(c)
    return c:IsSetCard(SET_ANCIENT_GEAR) and c:IsSpell() and c:IsSSetable()
end

-- Cible : Vérifie la présence d'une Magie valide dans le Deck
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil) end
end

-- Opération : Pose la carte sur le terrain
function s.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        local tc=g:GetFirst()
        if Duel.SSet(tp,tc)>0 then
            -- Impossible à activer ce tour (Condition classique de la Foreuse)
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetDescription(aux.Stringid(id,1))
            e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_CANNOT_TRIGGER)
            e1:SetReset(RESET_EVENT|RESETS_CANNOT_ACT|RESET_PHASE|PHASE_END)
            tc:RegisterEffect(e1)
        end
    end
end