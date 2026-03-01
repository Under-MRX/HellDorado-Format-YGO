--古代の機械素体
--Ancient Gear Frame
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
    e1:SetTarget(s.thtg)
    e1:SetOperation(s.thop)
    c:RegisterEffect(e1)
    
    --Clone l'effet pour l'Invocation Spéciale
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
end

-- Référence le Golem pour les interactions de base de données
s.listed_names={CARD_ANCIENT_GEAR_GOLEM}

-- Filtre : Cherche spécifiquement "Ancient Gear Golem" (ID: 83104731)
function s.thfilter(c)
    return c:IsCode(CARD_ANCIENT_GEAR_GOLEM) and c:IsAbleToHand()
end

-- Cible : Vérifie la présence de la carte dans le Deck
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

-- Opération : Ajoute la carte du Deck à la main
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end