-- Nom de ton Skill Secret
-- Scripted by TonNom
local s,id=GetID()
function s.initial_effect(c)
    -- On utilise la procédure de Skill de base (permet de retourner la carte)
    aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end

-- Filtre pour vérifier s'il y a un monstre Xyz "Numéro" (Archétype 0x48) chez l'adversaire
function s.num_filter(c)
    return c:IsType(TYPE_XYZ) and c:IsSetCard(0x48)
end

function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
    if not aux.CanActivateSkill(tp) then return false end
    if Duel.GetTurnPlayer()~=tp then return false end
    
    local c=e:GetHandler()
    
    -- ÉTAPE 1 : Si le Skill est face verso, on peut l'activer pour simplement le retourner
    if c:IsFacedown() then return true end
    
    -- ÉTAPE 2 : Si le Skill est déjà face recto, on peut l'activer pour faire l'effet (1 fois par duel)
    return Duel.GetFlagEffect(tp,id)==0 
        and Duel.IsExistingMatchingCard(s.num_filter,tp,0,LOCATION_EXTRA,1,nil)
end

function s.flipop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    
    -- Cas 1 : Le Skill est face verso -> On le met juste face recto sans faire l'effet
    if c:IsFacedown() then
        Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
        Duel.Hint(HINT_CARD,tp,id)
        return
    end
    
    -- Cas 2 : Le Skill est déjà face recto -> Le joueur a cliqué pour activer l'effet de vol
    -- On demande confirmation une dernière fois
    if not Duel.SelectYesNo(tp,aux.Stringid(id,0)) then return end
    
    -- On verrouille l'effet pour le reste du duel
    Duel.RegisterFlagEffect(tp,id,0,0,0)
    
    -- On récupère les Xyz Numéro de l'adversaire
    local g=Duel.GetMatchingGroup(s.num_filter,tp,0,LOCATION_EXTRA,nil)
    if #g==0 then return end
    
    -- Sélection aléatoire du Numéro
    local tc=g:RandomSelect(tp,1):GetFirst()
    if tc then
        Duel.DisableShuffleCheck()
        -- Envoi direct dans ton Extra Deck
        Duel.SendtoDeck(tc,tp,LOCATION_EXTRA,REASON_EFFECT)
    end
    
    -- Le Skill reste face recto (on ne met pas la ligne de fermeture 2<<32)
end