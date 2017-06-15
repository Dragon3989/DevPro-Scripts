function c1002150022.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WINDBEAST),6,3)
	c:EnableReviveLimit()
end
c100215002.ovfilte