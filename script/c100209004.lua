--剛鬼デストロイ・オーガ
--Gouki Destroy Ogre
--Script by nekrozar
function c100209004.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xfc),2)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c100209004.indtg)
	e1:SetValue(c100209004.indct)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100209004,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,100209004)
	e2:SetTarget(c100209004.sptg)
	e2:SetOperation(c100209004.spop)
	c:RegisterEffect(e2)
end
function c100209004.indtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c100209004.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE)~=0 then
		return 1
	else return 0 end
end
function c100209004.spfilter1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100209004.spfilter2(c,e,tp,zone)
	return c:IsSetCard(0xfc) and not c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c100209004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local zone=e:GetHandler():GetLinkedZone()
		return zone~=0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE,1-tp)>0
			and Duel.IsExistingMatchingCard(c100209004.spfilter1,1-tp,LOCATION_GRAVE,0,1,nil,e,1-tp)
			and Duel.IsExistingMatchingCard(c100209004.spfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,zone)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,PLAYER_ALL,LOCATION_GRAVE)
end
function c100209004.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local olc=Duel.GetLocationCount(1-tp,LOCATION_MZONE,1-tp)
	if olc>0 then
		if Duel.IsPlayerAffectedByEffect(1-tp,59822133) then olc=1 end
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(1-tp,aux.NecroValleyFilter(c100209004.spfilter1),1-tp,LOCATION_GRAVE,0,1,olc,nil,e,1-tp)
		if g1:GetCount()>0 then
			local ct=Duel.SpecialSummon(g1,0,1-tp,1-tp,false,false,POS_FACEUP)
			if ct<1 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
			local zone=c:GetLinkedZone()
			ct=math.min(Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone),ct)
			if ct>0 then
				if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100209004.spfilter2),tp,LOCATION_GRAVE,0,1,ct,nil,e,tp,zone)
				if g2:GetCount()>0 then
					Duel.BreakEffect()
					Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP,zone)
				end
			end
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c100209004.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c100209004.splimit(e,c)
	return not c:IsSetCard(0xfc)
end
