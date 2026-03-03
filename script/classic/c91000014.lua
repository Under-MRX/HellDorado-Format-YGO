--ズバババナイト
--Zubababa Knight
local s,id=GetID()
function s.initial_effect(c)
    --Ajouter 1 monstre "Zubaba" du Deck à la main
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_LVCHANGE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCountLimit(1,id)
    e1:SetTarget(s.thtg)
    e1:SetOperation(s.thop)
    c:RegisterEffect(e1)
    
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)

    --Ajouter 1 monstre "Gagaga" du Deck à la main (Effet conservé)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCountLimit(1,{id,1})
    e3:SetCondition(s.gathcon)
    e3:SetTarget(s.gathtg)
    e3:SetOperation(s.gathop)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_REMOVE)
    c:RegisterEffect(e4)
end

s.listed_series={SET_ZUBABA,SET_GAGAGA}
s.listed_names={id}

-- Filtre Zubaba
function s.zbthfilter(c)
    return c:IsSetCard(SET_ZUBABA) and c:IsMonster() and c:IsAbleToHand() and not c:IsCode(id)
end

-- Target Zubaba
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.zbthfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

-- Operation Zubaba
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local sc=Duel.SelectMatchingCard(tp,s.zbthfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
    if sc and Duel.SendtoHand(sc,nil,REASON_EFFECT)>0 then
        Duel.ConfirmCards(1-tp,sc)
        local lv=sc:GetLevel()
        local c=e:GetHandler()
        if c:IsRelateToEffect(e) and c:IsFaceup() and lv>0 then
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_CHANGE_LEVEL)
            e1:SetValue(lv)
            e1:SetReset(RESET_EVENT|RESETS_STANDARD_DISABLE)
            c:RegisterEffect(e1)
        end
    end
end

-- Fonctions Gagaga
function s.gathcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsReason(REASON_COST) and re:IsActivated() and re:IsActiveType(TYPE_XYZ) and c:IsPreviousLocation(LOCATION_OVERLAY)
end
function s.gathfilter(c)
    return c:IsSetCard(SET_GAGAGA) and c:IsMonster() and c:IsAbleToHand()
end
function s.gathtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.gathfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.gathop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.gathfilter,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end