--ペンデュラム・フュージョン
--Pendulum Fusion
--Scripted by Eerie Code
--Credits to MichaelLawrenceDee for the updated Card.IsCanBeFusionMaterial
function c100214004.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100214004+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100214004.target)
	e1:SetOperation(c100214004.activate)
	c:RegisterEffect(e1)
	if not c100214004.global_check then
		c100214004.global_check=true
		local f=Card.IsCanBeFusionMaterial
		Card.IsCanBeFusionMaterial=function(c,fc,ismon)
			if (c:GetSequence()==6 or c:GetSequence()==7) and c:IsLocation(LOCATION_SZONE) then
				return f(c,fc,true)
			end
			if c:IsCode(80604091) then return f(c,fc,true) end
			return f(c,fc,ismon)
		end
		local f2=Card.IsType
		Card.IsType=function(c,tp)
			if (c:GetSequence()==6 or c:GetSequence()==7) and c:IsLocation(LOCATION_SZONE) then
				local opt=bit.bor(c:GetOriginalType(),TYPE_SPELL)
				return bit.band(tp,opt)~=0
			end
			return f2(c,tp)
		end
	end
end
function c100214004.filter0(c,e)
	local seq=c:GetSequence()
	return (seq==6 or seq==7) and c:IsCanBeFusionMaterial(nil,true) and not c:IsImmuneToEffect(e)
end
function c100214004.filter1(c,e)
	return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c100214004.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c100214004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local mg1=Duel.GetMatchingGroup(Card.IsCanBeFusionMaterial,tp,LOCATION_MZONE,0,nil)
		if Duel.GetFieldCard(tp,LOCATION_SZONE,6) and Duel.GetFieldCard(tp,LOCATION_SZONE,7) then
			mg1:Merge(Duel.GetMatchingGroup(c100214004.filter0,tp,LOCATION_SZONE,0,nil,e))
		end
		local res=Duel.IsExistingMatchingCard(c100214004.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c100214004.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c100214004.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	local mg1=Duel.GetMatchingGroup(c100214004.filter1,tp,LOCATION_MZONE,0,nil,e)
	if Duel.GetFieldCard(tp,LOCATION_SZONE,6) and Duel.GetFieldCard(tp,LOCATION_SZONE,7) then
		mg1:Merge(Duel.GetMatchingGroup(c100214004.filter0,tp,LOCATION_SZONE,0,nil,e))
	end
	local sg1=Duel.GetMatchingGroup(c100214004.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c100214004.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
