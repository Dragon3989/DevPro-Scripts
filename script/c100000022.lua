--April 1st 2017 scripts
--DevPro - Sanctuary
--Script by dest
function c100000022.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c100000022.limcon)
	e1:SetOperation(c100000022.limop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100000022,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c100000022.negcon)
	e2:SetCost(c100000022.negcost)
	e2:SetTarget(c100000022.negtg)
	e2:SetOperation(c100000022.negop)
	c:RegisterEffect(e2)
end
function c100000022.limfilter(c,tp)
	return Duel.GetFieldCard(tp,LOCATION_SZONE,5) and c:GetSummonPlayer()==tp 
		and c:GetSummonLocation()==LOCATION_EXTRA and c:IsSetCard(0xfff)
end
function c100000022.limcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100000022.limfilter,1,nil,tp)
end
function c100000022.limop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(c100000022.chainlm)
end
function c100000022.chainlm(e,rp,tp)
	return tp==rp
end
function c100000022.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xfff)
end
function c100000022.negcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
		and Duel.IsExistingMatchingCard(c100000022.filter,tp,LOCATION_MZONE,0,3,nil)
end
function c100000022.cfilter(c)
	return c:IsSetCard(0xfff) and c:IsAbleToRemoveAsCost()
end
function c100000022.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100000022.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,3,nil) end
	if Duel.IsPlayerAffectedByEffect(tp,100000034) and Duel.IsExistingMatchingCard(c100000022.cfilter,tp,0,LOCATION_HAND+LOCATION_ONFIELD,3,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(100000034,0)) then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(1-tp,c100000022.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,3,3,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
		Duel.RegisterFlagEffect(tp,100000034,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c100000022.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,3,3,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c100000022.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function c100000022.negop(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	if Duel.NegateActivation(ev) and ec:IsRelateToEffect(re) then
		ec:CancelToGrave()
		Duel.SendtoDeck(ec,nil,2,REASON_EFFECT)
	end
end
