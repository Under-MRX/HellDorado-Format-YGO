function s.initial_effect(c)
	--If your opponent attacks while you control an EARTH monster, you choose the attack targets
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_PATRICIAN_OF_DARKNESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetCondition(function(e)
		return Duel.IsExistingMatchingCard(
			aux.FaceupFilter(Card.IsAttribute,ATTRIBUTE_EARTH),
			e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil
		)
	end)
	c:RegisterEffect(e1)

	--Add to your hand, or Special Summon, 1 Level 4 or lower "Magnet Warrior" monster in your GY
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.thsptg)
	e3:SetOperation(s.thspop)
	c:RegisterEffect(e3)
end