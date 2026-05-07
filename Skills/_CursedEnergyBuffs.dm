/obj/Skills/Buffs/SlotlessBuffs/Domain_Expansion
	name = "Domain Expansion"
	var/range = 15
	var/useShroud = 0
	var/demonName = "Domain"
	var/customTurfIcon = null
	var/customRoofIcon = null
	ActiveMessage = "expands a domain!"
	OffMessage = "domain fades..."

/obj/Skills/Buffs/SlotlessBuffs/Simple_Domain
	name = "Simple Domain"

/obj/Skills/Buffs/SlotlessBuffs/Hollow_Wicker_Basket
	name = "Hollow Wicker Basket"
	var/tmp/restores_movement = FALSE

/obj/Skills/Buffs/SlotlessBuffs/Domain_Lock
	name = "Domain Lock"
	TimerLimit = 0

/obj/Skills/Buffs/SlotlessBuffs/Dividing_Driver
	name = "Dividing Driver"

/obj/Skills/Buffs/SlotlessBuffs/Domain_Expansion/Cursed_Energy
	BuffName = "Domain Expansion Unleashed!"
	Mastery = -1
	UnrestrictedBuff = 1
	StrMult = 1.50
	ForMult = 1.50
	EndMult = 1.50
	SpdMult = 1.50
	DefMult = 1.50
	MakesArmor = 0
	TurfShift = 'WhiteTurfShift.dmi'
	TurfShiftInstant = 1
	OffMult = 1.50
	passives = list("TechniqueMastery" = 5, "BuffMastery" = 2, "MovementMastery" = 5)
	DarkChange = 1
