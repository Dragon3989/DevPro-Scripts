--April 1st 2017 scripts
--DevPro Staff - Jinzo28
--Script by dest
function c100000032.initial_effect(c)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c100000032.sumcon)
	e1:SetValue(SUMMON_TYPE_NORMAL)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	c:RegisterEffect(e2)
	--spsummon limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(c100000032.splimit)
	c:RegisterEffect(e3)
	--banish
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100000032,0))
	e4:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetTarget(c100000032.target)
	e4:SetOperation(c100000032.operation)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
end
function c100000032.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xfff)
end
function c100000032.sumcon(e,c,minc)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(c100000032.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,3,nil)
end
function c100000032.splimit(e,se,sp,st)
	return Duel.IsExistingMatchingCard(c100000032.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,3,nil)
end
function c100000032.rmfilter(c,code)
	return c:IsCode(code) and c:IsAbleToRemove()
end
function c100000032.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,564)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	local loc=LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE
	local g=Duel.GetMatchingGroup(c100000032.rmfilter,tp,loc,loc,nil,ac)
	local ct=g:GetCount()
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
	if ct>0 then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,ct,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*500)
	end
end
function c100000032.operation(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local loc=LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE
	local g=Duel.GetMatchingGroup(c100000032.rmfilter,tp,loc,loc,nil,ac)
	local ct=g:GetCount()
	if ct>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
		Duel.Damage(1-tp,ct*500,REASON_EFFECT)
	end
end
