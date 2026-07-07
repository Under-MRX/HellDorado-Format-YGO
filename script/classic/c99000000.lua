-- Nom de ton Skill Secret
-- Scripted by TonNom
local s,id=GetID()
function s.initial_effect(c)
    -- Procédure officielle pour les cartes Skill (évite l'erreur LOCATION_SKILL)
    aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end

-- Filtre pour vérifier si tu contrôles au moins un monstre "Numéro" (Archétype 0x48)
function s.num_control_filter(c)
    return c:IsFaceup() and c:IsSetCard(0x48)
end

function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
    if not aux.CanActivateSkill(tp) then return false end
    if Duel.GetTurnPlayer()~=tp then return false end
    
    local c=e:GetHandler()
    
    -- ÉTAPE 1 : Si le Skill est face verso, on peut le retourner face recto
    if c:IsFacedown() then return true end
    
    -- ÉTAPE 2 : Si le Skill est déjà face recto, on peut faire l'effet (1 fois par duel)
    return Duel.GetFlagEffect(tp,id)==0 
        and Duel.IsExistingMatchingCard(s.num_control_filter,tp,LOCATION_MZONE,0,1,nil)
end

function s.flipop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    
    -- Cas 1 : Le Skill est face verso -> On le met juste face recto via la procédure du jeu
    if c:IsFacedown() then
        return
    end
    
    -- Cas 2 : Le Skill est déjà face recto -> Fenêtre de confirmation pour l'effet
    if not Duel.SelectYesNo(tp,aux.Stringid(id,0)) then return end
    
    -- On verrouille le Skill pour le reste du duel (Une seule fois par Duel)
    Duel.RegisterFlagEffect(tp,id,0,0,0)
    
    -- Annonce l'activation du skill proprement (Correction HINT_CARD)
    Duel.Hint(HINT_CARD,tp,id)
    
    -- CRÉATION DE LA PROTECTION (Effet persistant sur le Terrain)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_INDESTRUCTIVABLE_BATTLE)
    e1:SetTargetRange(LOCATION_MZONE,0) -- Cible ton terrain
    e1:SetTarget(s.protection_tg)       -- Uniquement tes monstres "Numéro"
    e1:SetValue(s.battle_value)         -- Sauf contre un autre "Numéro"
    
    -- CORRECTION ERREUR PARAMETER 2 : On évite RESET_OPPO_TURN. 
    -- 2 End Phases = Ton tour actuel + Le tour complet de l'adversaire.
    e1:SetReset(RESET_PHASE+PHASE_END,2)
    Duel.RegisterEffect(e1,tp)
end

-- Cible de la protection : Tous tes monstres qui appartiennent à l'archétype "Numéro"
function s.protection_tg(e,c)
    return c:IsSetCard(0x48)
end

-- Règle de combat : Immunisé (true), SAUF si l'attaquant (c) est un "Numéro" (false)
function s.battle_value(e,c)
    return not c:IsSetCard(0x48)
end