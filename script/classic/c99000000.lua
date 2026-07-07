-- Nom de ton Skill Secret
-- Scripted by TonNom
local s,id=GetID()
function s.initial_effect(c)
    -- Procédure officielle pour les cartes Skill
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
    
    -- ÉTAPE 1 : Si le Skill est face verso, on peut le retourner
    if c:IsFacedown() then return true end
    
    -- ÉTAPE 2 : Si le Skill est déjà face recto, on peut faire l'effet (1 fois par duel)
    return Duel.GetFlagEffect(tp,id)==0 
        and Duel.IsExistingMatchingCard(s.num_control_filter,tp,LOCATION_MZONE,0,1,nil)
end

function s.flipop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    
    -- Cas 1 : Le Skill est face verso -> On le met juste face recto (Géré par la procedure)
    if c:IsFacedown() then
        return
    end
    
    -- Cas 2 : Le Skill est déjà face recto -> Activation de l'effet de protection
    if not Duel.SelectYesNo(tp,aux.Stringid(id,0)) then return end
    
    -- On verrouille le Skill pour le reste du duel
    Duel.RegisterFlagEffect(tp,id,0,0,0)
    
    -- Annonce l'activation du skill dans le journal de duel
    Duel.Hint(HINT_CARD,tp,id)
    
    -- CRÉATION DE LA PROTECTION (Effet persistant sur le Terrain)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_INDESTRUCTIVABLE_BATTLE)
    e1:SetTargetRange(LOCATION_MZONE,0) -- S'applique sur tes monstres
    e1:SetTarget(s.protection_tg)       -- Uniquement les monstres "Numéro"
    e1:SetValue(s.battle_value)         -- Sauf contre un autre "Numéro"
    
    -- Durée de l'effet : Jusqu'à la fin du prochain tour de l'adversaire
    e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
    Duel.RegisterEffect(e1,tp)
end

-- Cible de la protection : Tous tes monstres qui appartiennent à l'archétype "Numéro"
function s.protection_tg(e,c)
    return c:IsSetCard(0x48)
end

-- Règle de combat : Immunisé contre la destruction, SAUF si l'attaquant (c) est aussi un "Numéro"
function s.battle_value(e,c)
    return not c:IsSetCard(0x48)
end