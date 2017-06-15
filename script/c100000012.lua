--April 1st 2017 scripts
--DevPro - Banhammer
--Script by dest
function c100000012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCondition(c100000012.condition)
	e1:SetCost(c100000012.cost)
	e1:SetTarget(c100000012.target)
	e1:SetOperation(c100000012.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e3)
end
function c100000012.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function c100000012.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xfff)
end
function c100000012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c100000012.cfilter,1,nil) end
	if Duel.IsPlayerAffectedByEffect(tp,100000034) and Duel.CheckReleaseGroup(1-tp,c100000012.cfilter,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(100000034,0)) then
		local cg=Duel.SelectReleaseGroup(1-tp,c100000012.cfilter,1,1,nil)
		Duel.Release(cg,REASON_COST)
		Duel.RegisterFlagEffect(tp,100000034,RESET_PHASE+PHASE_END,0,1)
	else
		local cg=Duel.SelectReleaseGroup(tp,c100000012.cfilter,1,1,nil)
		Duel.Release(cg,REASON_COST)
	end
end
function c100000012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,eg:GetCount(),0,0)
end
function c100000012.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	if Duel.Destroy(eg,REASON_EFFECT)~=0 then
		local tc=eg:GetFirst()
		local rg=Group.CreateGroup()
		while tc do
			rg:AddCard(tc)
			local sg=Duel.GetMatchingGroup(Card.IsCode,1-tp,0x1f,0,nil,tc:GetCode())
			rg:Merge(sg)
			tc=eg:GetNext()
		end
		if rg:GetCount()>0 then
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
