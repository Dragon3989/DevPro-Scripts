--April 1st 2017 scripts
--DevPro Staff - 17
--Script by dest
function c100000000.initial_effect(c)
	c:SetUniqueOnField(1,0,100000000)
	--xyz summon
	aux.AddXyzProcedure(c,c100000000.ovfilter,4,2)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100000000,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetCondition(c100000000.descon)
	e1:SetCost(c100000000.cost)
	e1:SetTarget(c100000000.destg)
	e1:SetOperation(c100000000.desop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e2:SetCondition(c100000000.descon2)
	c:RegisterEffect(e2)
end
function c100000000.ovfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA and c:IsSetCard(0xfff)
end
function c100000000.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x1fff)
end
function c100000000.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c100000000.descon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c100000000.filter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c100000000.descon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100000000.filter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c100000000.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then
		if e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0xfff) then
			return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		end
		return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0xfff) then
		e:SetCategory(CATEGORY_REMOVE)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	else
		e:SetCategory(CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
end
function c100000000.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	if e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0xfff) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	else
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
