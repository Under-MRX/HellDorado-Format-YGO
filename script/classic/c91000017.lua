--Adamancipator Signs
local s,id=GetID()

function s.initial_effect(c)
    --Activate only 1 per turn
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
end

--Rock monster in GY
function s.spfilter(c,e,tp)
    return c:IsRace(RACE_ROCK)
        and c:IsCanBeSpecialSummoned(
            e,0,tp,false,false,POS_FACEUP_DEFENSE
        )
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then
        return chkc:IsLocation(LOCATION_GRAVE)
            and chkc:IsControler(tp)
            and s.spfilter(chkc,e,tp)
    end
    if chk==0 then
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
            and Duel.IsExistingTarget(
                s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp
            )
    end

    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(
        tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp
    )
    Duel.SetOperationInfo(
        0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE
    )
end

--Level 4 or lower Rock monster
function s.deckfilter(c)
    return c:IsRace(RACE_ROCK)
        and c:IsMonster()
        and c:IsLevelBelow(4)
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if not tc or not tc:IsRelateToEffect(e) then
        return
    end

    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
        return
    end

    if Duel.SpecialSummon(
        tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE
    )==0 then
        return
    end

    --If an Adamancipator monster was summoned
    if not tc:IsSetCard(0x140) then
        return
    end

    if not Duel.IsExistingMatchingCard(
        s.deckfilter,tp,LOCATION_DECK,0,1,nil
    ) then
        return
    end

    if not Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
        return
    end

    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local g=Duel.SelectMatchingCard(
        tp,s.deckfilter,tp,LOCATION_DECK,0,1,1,nil
    )

    local sc=g:GetFirst()
    if sc then
        Duel.MoveSequence(sc,SEQ_DECKTOP)
        Duel.ConfirmCards(1-tp,sc)
    end
end
