--Switcheroo
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
    Duel.RegisterFlagEffect(ep,id,0,0,0)

 local g=Duel.GetMatchingGroup(s.num_filter,tp,0,LOCATION_EXTRA,nil)
    if #g==0 then return end
    
    -- Tu regardes (confirmes) l'Extra Deck de l'adversaire pour pouvoir choisir
    Duel.ConfirmCards(tp,g)
    
    -- TU sélectionnes manuellement 1 carte parmi les cibles valides
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local tc=g:Select(tp,1,1,nil):GetFirst()
    if tc then
        -- L'ASTUCE : On triche avec le moteur du jeu.
        -- On retire la carte de l'Extra Deck adverse sans déclencher d'effet (mouvement fantôme)
        Duel.Remove(tc,POS_FACEDOWN,REASON_RULE,1-tp) 
        
        -- On ré-initialise son contrôle pour dire qu'elle t'appartient à TOI (tp) pour ce duel
        tc:SetOwner(tp)
        
        -- Maintenant que le jeu pense qu'elle est à toi, SendtoDeck vers ton Extra Deck fonctionne enfin !
        Duel.DisableShuffleCheck()
        Duel.SendtoDeck(tc,tp,LOCATION_EXTRA,REASON_EFFECT)
    end
end
end