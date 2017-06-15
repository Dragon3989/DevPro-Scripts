--April 1st 2017 scripts
--DevPro Staff - Caz
--Script by dest
function c100000008.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100000008,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c100000008.spcost)
	e1:SetTarget(c100000008.sptg)
	e1:SetOperation(c100000008.spop)
	c:RegisterEffect(e1)
end
function c100000008.costfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
end
function c100000008.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100000008.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	if Duel.IsPlayerAffectedByEffect(tp,100000034) and Duel.IsExistingMatchingCard(c100000008.costfilter,tp,0,LOCATION_GRAVE,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(100000034,0)) then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(1-tp,c100000008.costfilter,tp,0,LOCATION_GRAVE,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
		local tc=g:GetFirst()
		e:SetLabelObject(tc)
		Duel.RegisterFlagEffect(tp,100000034,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c100000008.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
		local tc=g:GetFirst()
		e:SetLabelObject(tc)
	end
end
function c100000008.filter(c,e,tp)
	return c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100000008.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100000008.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c100000008.spop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetRange(LOCATION_REMOVED)
	e0:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e0:SetCountLimit(1)
	e0:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
	e0:SetCondition(c100000008.thcon)
	e0:SetOperation(c100000008.thop)
	e0:SetLabel(0)
	tc:RegisterEffect(e0)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100000008.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tg=g:GetFirst()
	if g:GetCount()>0 and Duel.SpecialSummonStep(tg,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tg:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tg:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SYNCHRO_LEVEL)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetValue(c100000008.slevel)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tg:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_XYZ_LEVEL)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetValue(c100000008.xyzlv)
		e4:SetReset(RESET_EVENT+0x1fe0000)
		tg:RegisterEffect(e4)
		Duel.SpecialSummonComplete()
	end
end
function c100000008.slevel(e,c)
	return 4*65536
end
function c100000008.xyzlv(e,c,rc)
	return 0x40000
end
function c100000008.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c100000008.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	c:SetTurnCounter(ct+1)
	if ct==1 then
		local p=1-tp
		if c:IsControler(1-tp) then p=tp end
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(p,c)
	else e:SetLabel(1) end
end
