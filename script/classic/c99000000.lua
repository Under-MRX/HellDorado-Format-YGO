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
        -- ASTUCE POUR FORCER LE JEU : 
        -- On recrée informatiquement la carte dans ton Extra Deck et on supprime celle de l'adversaire
        -- C'est la seule méthode infaillible pour tricher avec les règles de propriété du core YGOPro
        local code = tc:GetCode()
        
        -- 1. On supprime la carte de l'Extra Deck adverse (en la bannissant face cachée ou en la détruisant sans trigger d'effet)
        Duel.Exile(tc, REASON_RULE)
        
        -- 2. On génère une copie exacte de cette carte directement dans TON Extra Deck
        local token = Duel.CreateToken(tp, code)
        Duel.SendtoDeck(token, tp, LOCATION_EXTRA, REASON_EFFECT)
        
        -- Optionnel : Petit message pour confirmer l'obtention de la carte
        Duel.Hint(HINT_CARD, tp, code)
    end
end