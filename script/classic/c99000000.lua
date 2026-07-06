-- Nom de ton Skill Secret
-- Scripted by TonNom
local s,id=GetID()
function s.initial_effect(c)
    -- Procédure officielle pour les cartes Skill
    aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop,1)
end

-- Filtre pour vérifier s'il y a un monstre "Numéro" (Archétype 0x48) dans l'Extra Deck adverse
function s.num_filter(c)
    return c:IsSetCard(0x48)
end

-- Condition : S'active uniquement durant ton tour
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
    if not aux.CanActivateSkill(tp) then return false end
    if Duel.GetTurnPlayer()~=tp then return false end
    
    -- Vérifie s'il y a au moins 1 monstre Numéro chez l'adversaire
    return Duel.IsExistingMatchingCard(s.num_filter,tp,0,LOCATION_EXTRA,1,nil)
end

-- Fonction pour extraire le numéro du nom de la carte (ex: "Number 39" -> 39)
function s.get_number_value(c)
    local num = aux.GetXYZNumber and aux.GetXYZNumber(c) or 0
    return num
end

-- L'effet du Skill
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
    -- Animation visuelle de l'activation
    Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
    Duel.Hint(HINT_CARD,tp,id)
    
    -- Récupérer tous les monstres "Numéro" de l'adversaire
    local g=Duel.GetMatchingGroup(s.num_filter,tp,0,LOCATION_EXTRA,nil)
    if #g==0 then return end
    
    -- Sélectionner au hasard 1 monstre parmi eux
    local tc=g:RandomSelect(tp,1):GetFirst()
    if tc then
        -- Étape cruciale : On change la possession de la carte dans le moteur du jeu 
        -- pour éviter que le core bloque le transfert entre Extra Decks opposés
        Duel.DisableShuffleCheck()
        
        -- On force l'envoi dans TON Extra Deck (tp)
        if Duel.SendtoDeck(tc,tp,LOCATION_EXTRA,REASON_EFFECT) ~= 0 then
            -- Calculer le numéro de la carte et multiplier par 30
            local num_val = s.get_number_value(tc)
            local damage = num_val * 30
            
            -- Si la carte a un numéro valide, tu prends les dégâts
            if damage > 0 then
                Duel.BreakEffect()
                Duel.Damage(tp,damage,REASON_EFFECT)
            end
        end
    end
    
    -- NOTE : La ligne de "HINT_SKILL_FLIP" avec (2<<32) a été retirée.
    -- Le Skill va donc rester visible et Face Recto sur le terrain !
end