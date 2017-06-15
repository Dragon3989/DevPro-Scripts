--April 1st 2017 scripts
--DevPro Staff - Bromantic
--Script by dest
function c100000016.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xfff),aux.NonTuner(Card.IsSetCard,0xfff),1)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100000016,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCountLimit(1)
	e2:SetLabel(0)
	e2:SetCost(c100000016.drcost)
	e2:SetTarget(c100000016.drtg)
	e2:SetOperation(c100000016.drop)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetTarget(c100000016.reptg)
	c:RegisterEffect(e3)
end
function c100000016.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	if Duel.IsPlayerAffectedByEffect(tp,100000034) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,0,LOCATION_HAND,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(100000034,0)) then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DISCARD)
		local g=Duel.SelectMatchingCard(1-tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
		if g:GetFirst():IsSetCard(0xfff) then e:SetLabel(1) end
		Duel.RegisterFlagEffect(tp,100000034,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
		if g:GetFirst():IsSetCard(0xfff) then e:SetLabel(1) end
	end
end
function c100000016.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	local ct=1
	if e:GetLabel()==1 then ct=2 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c100000016.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c100000016.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function c100000016.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsReason(REASON_EFFECT) and Duel.GetFlagEffect(tp,100000116)==0
		and Duel.IsExistingMatchingCard(c100000016.filter,tp,LOCATION_GRAVE,0,1,nil) end
	if Duel.SelectYesNo(tp,aux.Stringid(100000016,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c100000016.filter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		if Duel.GetFlagEffect(tp,100000016)==0 then
			Duel.RegisterFlagEffect(tp,100000016,RESET_PHASE+PHASE_END,0,1)
		else
			Duel.RegisterFlagEffect(tp,100000116,RESET_PHASE+PHASE_END,0,1)
		end
		return true
	else return false end
end
