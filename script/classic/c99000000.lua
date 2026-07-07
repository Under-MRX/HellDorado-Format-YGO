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
	--used skill flag register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
    
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