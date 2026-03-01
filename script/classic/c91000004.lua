--電磁石の戦士γ (Version Tuto uniquement)
--Gamma The Electromagnet Warrior (Modified to Search)
local s,id=GetID()
function s.initial_effect(c)
    --Ajouter à la main (Tuto) lors de l'Invocation Normale ou Spéciale
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCountLimit(1,id)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
    
    --Clone l'effet pour l'Invocation Spéciale
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
end

s.listed_series={SET_MAGNET_WARRIOR}
s.listed_names={id}

-- Filtre : Magnet Warrior de Niveau 4 ou moins (sauf lui-même)
function s.filter(c)
    return c:IsSetCard(SET_MAGNET_WARRIOR) and not c:IsCode(id) and c:IsLevelBelow(4) and c:IsAbleToHand()
end

-- Cible : Vérifie si un monstre valide existe dans le Deck
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

-- Opération : Ajoute la carte du Deck à la main
function s.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end