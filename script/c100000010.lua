--April 1st 2017 scripts
--DevPro - Flame War
--Script by dest
function c100000010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cannot spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetCondition(c100000010.discon)
	e2:SetTarget(c100000010.splimit)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100000010,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c100000010.thcon)
	e3:SetTarget(c100000010.thtg)
	e3:SetOperation(c100000010.thop)
	c:RegisterEffect(e3)
end
function c100000010.cfilter(c)
	if not c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ) then return false end
	local g=nil
	if c:IsType(TYPE_XYZ) then
		g=c:GetOverlayGroup()
	else
		g=c:GetMaterial()
	end
	return c:IsSetCard(0x1fff) and g:GetCount()>0 and not g:IsExists(c100000010.filter,1,nil)
end
function c100000010.filter(c)
	return not c:IsSetCard(0xfff)
end
function c100000010.discon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c100000010.cfilter,tp,LOCATION_MZONE,0,2,nil)
end
function c100000010.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA)
end
function c100000010.thcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_EXTRA)
end
function c100000010.thfilter(c)
	return c:IsSetCard(0xfff) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c100000010.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100000010.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100000010.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
