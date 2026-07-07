-- Skill Universal

local s,id=GetID()
local SET_NUMBER = 0x48

function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end

function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,id)>0 then return end
	return aux.CanActivateSkill(tp)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	Duel.RegisterFlagEffect(tp,id,0,0,0)

	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_INDESTRUCTIVABLE_BATTLE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    
    e1:SetTarget(s.num_target) 
    
    e1:SetValue(aux.NOT(aux.TargetBoolFunction(Card.IsSetCard,SET_NUMBER)))
    
    e1:SetReset(RESET_PHASE+PHASE_END,2)
    
    Duel.RegisterEffect(e1,tp)

end
function s.num_target(e,c)
    return c:IsFaceup() and c:IsSetCard(SET_NUMBER)
end

