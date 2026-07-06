-- Nom de ton Skill Secret
-- Scripted par  MRX
local s,id=GetID()
function s.initial_effect(c)
    -- Règle : Un seul Skill de ce nom sur le terrain
    c:SetUniqueOnField(1,0,id)
    
    -- 1. EFFET AUTOMATIQUE : Se retourne face visible au début du Duel
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_STARTUP)
    e1:SetCountLimit(1)
    e1:SetRange(LOCATION_SKILL)
    e1:SetOperation(s.flip_op)
    c:RegisterEffect(e1)
    
    -- 2. EFFET ACTIF : Voler un monstre "Numéro" (Une fois par Duel)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SKILL)
    e2:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL) -- UNE SEULE FOIS PAR DUEL
    e2:SetCondition(s.eff_con)
    e2:SetTarget(s.eff_tg)
    e2:SetOperation(s.eff_op)
    c:RegisterEffect(e2)
end

-- Force le Skill à se retourner au début de la partie
function s.flip_op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_CARD,0,id)
    Duel.MoveToField(c,tp,tp,LOCATION_SKILL,POS_FACEUP,true)
    Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
end

-- Le Skill doit être face visible pour être activé
function s.eff_con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsFaceup() and Duel.GetTurnPlayer()==tp
end

-- Filtre pour vérifier s'il y a un monstre "Numéro" (Archtétype 0x48) dans l'Extra Deck adverse
function s.num_filter(c)
    return c:IsSetCard(0x48) -- 0x48 est l'archétype officiel des monstres "Number" (Numéro)
end

function s.eff_tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.num_filter,tp,0,LOCATION_EXTRA,1,nil) end
end

-- Fonction magique pour extraire le numéro du nom de la carte (ex: "Number 39" -> 39)
function s.get_number_value(c)
    local code = c:GetCode()
    -- On utilise l'API EDOPRO pour récupérer la valeur officielle du "Numéro"
    -- Si l'API globale n'est pas dispo, on peut aussi lire l'ID de la carte, mais aux.GetXYZNumber est le standard
    local num = aux.GetXYZNumber and aux.GetXYZNumber(c) or 0
    return num
end

function s.eff_op(e,tp,eg,ep,ev,re,r,rp)
    -- Animation visuelle du Skill
    Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
    
    -- Récupérer tous les monstres "Numéro" de l'adversaire
    local g=Duel.GetMatchingGroup(s.num_filter,tp,0,LOCATION_EXTRA,nil)
    if #g==0 then return end
    
    -- Sélectionner au hasard 1 monstre parmi eux
    local tc=g:RandomSelect(tp,1):GetFirst()
    if tc then
        -- Envoyer la carte dans TON Extra Deck (Changement permanent pour le duel)
        Duel.SendtoDeck(tc,tp,LOCATION_EXTRA,REASON_EFFECT)
        
        -- Calculer le numéro de la carte (ex: 39) et multiplier par 30
        local num_val = s.get_number_value(tc)
        local damage = num_val * 30
        
        -- Si la carte a un numéro valide (supérieur à 0), tu prends les dégâts
        if damage > 0 then
            Duel.BreakEffect()
            Duel.Damage(tp,damage,REASON_EFFECT)
        end
    end
end