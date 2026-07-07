-- Skill Universal
local s,id=GetID()
local SET_NUMBER = 0x48

function s.initial_effect(c)
    aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end

function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetFlagEffect(tp,id)>0 then return false end
    return aux.CanActivateSkill(tp)
end

function s.flipop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,tp,id)
    Duel.RegisterFlagEffect(tp,id,0,0,0)

    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_INDESTRUCTIVABLE_BATTLE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    
    -- Le filtre magique est ici : on calcule tout dans le Target
    e1:SetTarget(s.protection_tg) 
    
    -- On force la valeur à 1 (un Int pur), ce qui signifie "Invincible" de base
    e1:SetValue(1)
    
    e1:SetReset(RESET_PHASE+PHASE_END,2)
    Duel.RegisterEffect(e1,tp)
end

-- La logique est déplacée ici pour éviter le bug de type :
function s.protection_tg(e,c)
    -- ÉTAPE 1 : Le monstre protégé doit être un "Numéro" à toi
    if not (c:IsFaceup() and c:IsSetCard(SET_NUMBER)) then return false end
    
    -- ÉTAPE 2 : On récupère le monstre qui l'attaque ou qu'il attaque
    local a=Duel.GetAttacker()
    local d=Duel.GetAttackTarget()
    
    -- Si un combat est en cours, on cherche le monstre adverse
    local opp = nil
    if a == c then opp = d end
    if d == c then opp = a end
    
    -- Si l'adversaire est un monstre "Numéro", la protection NE S'APPLIQUE PAS (on renvoie false)
    if opp and opp:IsSetCard(SET_NUMBER) then
        return false
    end
    
    -- Dans tous les autres cas (pas un numéro, ou pas de combat), la protection est active
    return true
end