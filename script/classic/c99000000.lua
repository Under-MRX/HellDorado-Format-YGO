-- Nom de ton Skill Secret
-- Scripted by TonNom
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop,1)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--once per duel check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp) and Duel.IsPlayerCanDraw(tp,1)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
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