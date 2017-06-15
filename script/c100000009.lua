--April 1st 2017 scripts
--DevPro - Barricade
--Script by dest
function c100000009.initial_effect(c)
	--Activate(without effect)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100000009,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Activate(with effect)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100000009,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCondition(c100000009.negcon)
	e2:SetCost(c100000009.negcost)
	e2:SetTarget(c100000009.negtg)
	e2:SetOperation(c100000009.negop)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100000009,1))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,100000009)
	e3:SetCondition(c100000009.negcon)
	e3:SetCost(c100000009.negcost)
	e3:SetTarget(c100000009.negtg)
	e3:SetOperation(c100000009.negop)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100000009,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c100000009.sptg)
	e4:SetOperation(c100000009.spop)
	c:RegisterEffect(e4)
	--clear
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetOperation(c100000009.clearop)
	c:RegisterEffect(e5)
	local ng=Group.CreateGroup()
	ng:KeepAlive()
	e1:SetLabelObject(ng)
	e2:SetLabelObject(ng)
	e3:SetLabelObject(ng)
	e4:SetLabelObject(ng)
	e5:SetLabelObject(ng)
end
function c100000009.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev)
end
function c100000009.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xfff)
end
function c100000009.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c100000009.cfilter,1,nil) and Duel.GetFlagEffect(tp,100000009)==0 end
	if Duel.IsPlayerAffectedByEffect(tp,100000034) and Duel.CheckReleaseGroup(1-tp,c100000009.cfilter,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(100000034,0)) then
		local cg=Duel.SelectReleaseGroup(1-tp,c100000009.cfilter,1,1,nil)
		Duel.Release(cg,REASON_COST)
		local tc=cg:GetFirst()
		tc:RegisterFlagEffect(100000109,RESET_EVENT+0x1fe0000,0,0)
		e:GetLabelObject():AddCard(tc)
		Duel.RegisterFlagEffect(tp,100000034,RESET_PHASE+PHASE_END,0,1)
	else
		local cg=Duel.SelectReleaseGroup(tp,c100000009.cfilter,1,1,nil)
		Duel.Release(cg,REASON_COST)
		local tc=cg:GetFirst()
		tc:RegisterFlagEffect(100000109,RESET_EVENT+0x1fe0000,0,0)
		e:GetLabelObject():AddCard(tc)
	end
	Duel.RegisterFlagEffect(tp,100000009,RESET_PHASE+PHASE_END,0,1)
end
function c100000009.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c100000009.negop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
function c100000009.spfilter(c,e,tp)
	return c:GetFlagEffect(100000109)~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100000009.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c100000009.spop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(c100000009.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(c100000009.spfilter),tp,0,LOCATION_GRAVE,nil,e,tp)
	if g1:GetCount()>0 and e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
	end
	if g2:GetCount()>0 and e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then 
		Duel.SpecialSummon(g2,0,tp,1-tp,false,false,POS_FACEUP)
	end
	e:GetLabelObject():Clear()
end
function c100000009.clearop(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():Clear()
end
