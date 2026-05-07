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
	Slotless = 1
				TimerLimit = 4
				Cooldown = 150
				CooldownStatic = 1
				BuffName = "Simple Domain"
				IconLock = 'Bubbly_Cursed_Energy_Aura.dmi'
				LockX = -16
				LockY = -9
				IconLockBlend = 1
				IconUnder = 1
				OverlaySize = 1.2
				TopOverlayLock = 'DarknessGlow.dmi'
				TopOverlayX = -32
				TopOverlayY = -32
				passives = list("Siphon" = 5, "FluidForm" = 1, "PureReduction" = 1.5, "SpaceWalk" = 1, "StaticWalk" = 1, "Void" = 1)
				ActiveMessage = "expands a Simple Domain around themselves."
				OffMessage = "lets their Simple Domain collapse."

				Cooldown(var/modify = 1, var/Time, mob/p, var/announce_cd = 1)
					..(modify, 1500, p, announce_cd)

/obj/Skills/Buffs/SlotlessBuffs/Hollow_Wicker_Basket
	name = "Hollow Wicker Basket"
	var/tmp/restores_movement = FALSE
		Slotless = 1
				TimerLimit = 4
				Cooldown = 100
				CooldownStatic = 1
				BuffName = "Hollow Wicker Basket"
				passives = list("PureReduction" = 9999)
				IconLock = 'HolyDome_Wicker_Shimmer.dmi'
				LockX = -158
				LockY = -96
				ActiveMessage = "forms Hollow Wicker Basket, a woven barrier distorting the space around them"
				OffMessage = "releases the barrier around them"

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
