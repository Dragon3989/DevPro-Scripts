--April 1st 2017 scripts
--DevPro Staff - Aukora
--Script by dest
function c100000018.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0xfff),1)
	c:EnableReviveLimit()
	--banish
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100000018,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,100000018)
	e1:SetCost(c100000018.cost)
	e1:SetTarget(c100000018.target)
	e1:SetOperation(c100000018.operation)
	c:RegisterEffect(e1)
end
function c100000018.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,5)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil)==5 end
	local g2=Duel.GetDecktopGroup(1-tp,5)
	if Duel.IsPlayerAffectedByEffect(tp,100000034) and g2:FilterCount(Card.IsAbleToRemoveAsCost,nil)==5
		and Duel.SelectYesNo(tp,aux.Stringid(100000034,0)) then
		Duel.Remove(g2,POS_FACEUP,REASON_COST)
		Duel.RegisterFlagEffect(tp,100000034,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c100000018.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_HAND,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	e:SetLabel(Duel.SelectOption(tp,70,71,72))
	local typ=TYPE_MONSTER
	if e:GetLabel()==1 then typ=TYPE_SPELL end
	if e:GetLabel()==2 then typ=TYPE_TRAP end
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_HAND,nil,typ)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,LOCATION_HAND)
end
function c100000018.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,g)
		local typ=TYPE_MONSTER
		if e:GetLabel()==1 then typ=TYPE_SPELL end
		if e:GetLabel()==2 then typ=TYPE_TRAP end
		local tg=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_HAND,nil,typ)
		if tg:GetCount()>0 then
			Duel.Destroy(tg,REASON_EFFECT)
		end
		Duel.ShuffleHand(1-tp)
	end
end
