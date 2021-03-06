--スカイスクレイパー・シュート
--Skydive Scorcher
--Scripted by Eerie Code
function c100213006.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTarget(c100213006.target)
	e1:SetOperation(c100213006.activate)
	c:RegisterEffect(e1)
end
function c100213006.filter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x3008) and c:IsType(TYPE_FUSION)
		and Duel.IsExistingMatchingCard(c100213006.desfilter,tp,0,LOCATION_MZONE,1,nil,c:GetAttack())
end
function c100213006.desfilter(c,atk)
	return c:IsFaceup() and c:GetAttack()>atk
end
function c100213006.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100213006.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c100213006.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tg=Duel.SelectTarget(tp,c100213006.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local atk=tg:GetFirst():GetAttack()
	local g=Duel.GetMatchingGroup(c100213006.desfilter,tp,0,LOCATION_MZONE,nil,atk)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetTargetPlayer(1-tp)
	local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	local dam=0
	if fc and c100213006.ffilter(fc) then
		dam=g:GetSum(Card.GetBaseAttack)
	else
		g,dam=g:GetMaxGroup(Card.GetBaseAttack)
	end
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,1,1-tp,dam)
end
function c100213006.ffilter(c)
	return c:IsFaceup() and (c:IsSetCard(0xf6) or c:IsCode(63035430,47596607))
end
function c100213006.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(c100213006.desfilter,tp,0,LOCATION_MZONE,nil,tc:GetAttack())
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)>0 then
		local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_GRAVE)
		if og:GetCount()==0 then return end
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		local dam=0
		if fc and c100213006.ffilter(fc) then
			dam=og:GetSum(Card.GetBaseAttack)
		else
			g,dam=og:GetMaxGroup(Card.GetBaseAttack)
		end
		Duel.Damage(p,dam,REASON_EFFECT)
	end
end
