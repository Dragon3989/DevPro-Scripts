--April 1st 2017 scripts
--DevPro Staff - dest
--Script by dest
function c100000034.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cost redirect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(100000034)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c100000034.ccon)
	c:RegisterEffect(e2)
	--remove overlay replace
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100000034,1))
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,100000034)
	e3:SetCondition(c100000034.rcon)
	e3:SetOperation(c100000034.rop)
	c:RegisterEffect(e3)
	--xyz summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100000034,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c100000034.cost)
	e4:SetTarget(c100000034.xyztg)
	e4:SetOperation(c100000034.xyzop)
	c:RegisterEffect(e4)
	--synchro summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(100000034,3))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetCost(c100000034.cost)
	e5:SetTarget(c100000034.syntg)
	e5:SetOperation(c100000034.synop)
	c:RegisterEffect(e5)
	--fusion summon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(100000034,4))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1)
	e6:SetCost(c100000034.cost)
	e6:SetTarget(c100000034.fustg)
	e6:SetOperation(c100000034.fusop)
	c:RegisterEffect(e6)
end
function c100000034.ccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,100000034)==0
end
function c100000034.rfilter(c,oc)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
		and c:CheckRemoveOverlayCard(tp,oc,REASON_COST)
end
function c100000034.rcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return bit.band(r,REASON_COST)~=0 and re:IsHasType(0x7e0) and Duel.IsPlayerAffectedByEffect(tp,100000034)
		and re:IsActiveType(TYPE_XYZ) and ep==e:GetOwnerPlayer() and rc:IsSetCard(0xfff)
		and Duel.IsExistingMatchingCard(c100000034.rfilter,tp,0,LOCATION_MZONE,1,nil,ev)
end
function c100000034.rop(e,tp,eg,ep,ev,re,r,rp)
	local ct=bit.band(ev,0xffff)
	local tg=Duel.SelectMatchingCard(1-tp,c100000034.rfilter,tp,0,LOCATION_MZONE,1,1,nil,ct)
	tg:GetFirst():RemoveOverlayCard(1-tp,ct,ct,REASON_COST)
	Duel.RegisterFlagEffect(tp,100000034,RESET_PHASE+PHASE_END,0,1)
end
function c100000034.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(100000134)==0 end
	e:GetHandler():RegisterFlagEffect(100000134,RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END,0,1)
end
function c100000034.xyz2filter(c,e,tp)
	return c:IsFaceup() and
		Duel.IsExistingMatchingCard(c100000034.xyz3filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,c)
end
function c100000034.xyz3filter(c,e,tp,mc)
	local mg=Group.FromCards(c,mc)
	return c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c100000034.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
end
function c100000034.xyzfilter(c,mg)
	return c:IsXyzSummonable(mg,2,2) and c:IsSetCard(0xfff)
end
function c100000034.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c100000034.xyz2filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g1=Duel.SelectTarget(tp,c100000034.xyz2filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	local tc1=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,c100000034.xyz3filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,tc1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,1,0,0)
	g1:Merge(g2)
	Duel.SetTargetCard(g1)
end
function c100000034.xyzop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()<2 then return end
	local tg=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
	Duel.BreakEffect()
	local xyzg=Duel.GetMatchingGroup(c100000034.xyzfilter,tp,LOCATION_EXTRA,0,nil,g)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,g)
	end
end
function c100000034.tfilter(c,e,tp)
	return c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c100000034.synfilter,tp,LOCATION_EXTRA,0,1,nil,c)
end
function c100000034.synfilter(c,mc)
	return c:IsSetCard(0xfff) and c:IsSynchroSummonable(mc)
end
function c100000034.syntg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c100000034.tfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c100000034.tfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c100000034.tfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c100000034.synop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local g=Duel.GetMatchingGroup(c100000034.synfilter,tp,LOCATION_EXTRA,0,nil,tc)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),tc)
	end
end
function c100000034.spfilter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c100000034.spfilter2(c,e,tp,m,f,chkf,mg)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0xfff) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and mg:IsExists(c100000034.spfilter3,1,nil,c,m,chkf,e,tp)
end
function c100000034.spfilter2gc(c,e,tp,m,f,gc)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0xfff) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,gc)
end
function c100000034.spfilter3(c,fusc,m,chkf,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeEffectTarget(e)
		and fusc:CheckFusionMaterial(m,c,chkf) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100000034.spfilter4(c,e,tp,mg)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c100000034.spfilter2gc,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,nil,c)
end
function c100000034.spfilter5(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100000034.fustg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end	
	if chk==0 then
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local mg1=Duel.GetFusionMaterial(tp)
		local mg2=Duel.GetMatchingGroup(c100000034.spfilter5,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp)
		mg1:Merge(mg2)
		local res=Duel.IsExistingMatchingCard(c100000034.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf,mg2)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c100000034.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf,mg2)
			end
		end
		return res and Duel.IsPlayerCanSpecialSummonCount(tp,2)
	end
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	local mg1=Duel.GetFusionMaterial(tp)
	local mg2=Duel.GetMatchingGroup(c100000034.spfilter5,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp,mg1)
	mg1:Merge(mg2)
	local res=Duel.IsExistingMatchingCard(c100000034.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf,mg2)
	if not res then
		if Duel.GetChainMaterial(tp)~=nil then
			local fgroup=ce:GetTarget()
			mg1=fgroup(ce,e,tp)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c100000034.spfilter4,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp,mg1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c100000034.fusop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) or Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	if tc:IsImmuneToEffect(e) then return end
	local mg1=Duel.GetFusionMaterial(tp):Filter(c100000034.spfilter1,tc,e)
	local sg1=Duel.GetMatchingGroup(c100000034.spfilter2gc,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,tc)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c100000034.spfilter2gc,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,tc)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc2=tg:GetFirst()
		if sg1:IsContains(tc2) and (sg2==nil or not sg2:IsContains(tc2) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc2,mg1,tc)
			tc2:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc2,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc2,mg2,tc)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc2:CompleteProcedure()
	end
end
