--Universel Skill
--Created by MRX

local s,id=GetID()

function s.initial_effect(c)
    aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop,1)
end

function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
    if Duel.(ep,id)>0 then return end
    return aux.CanActivateSkill(tp)
end

function s.flipop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
    Duel.Hint(HINT_CARD,tp,id)
    Duel.RegisterFlagEffect(ep,id,0,0,0)
    
    --Lancer de dé
    local dice = Duel.TossDice(tp, 1)
    --Cacul du gain de LP : Résultat x 200
    local gain = dice * 200

    Duel.Recover(tp, gain, REASON_EFFECT)

end

