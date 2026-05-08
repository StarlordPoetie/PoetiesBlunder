/obj/Skills/Buffs/SlotlessBuffs/Domain_Expansion
	name = "Domain Expansion"
	var/tmp/list/effected = list()
	var/range = 15
	var/identifier = null
	var/useShroud = 0
	var/demonName = "Domain"
	var/customTurfIcon = null
	var/customRoofIcon = null
	ActiveMessage = "expands a domain!"
	OffMessage = "domain fades..."

	proc/animation(mob/p, range)
		if(!range)
			range = 8

		effected = list()

		for(var/atom/M in range(range, p))
			spawn()
				animate(M, color = list(-1,0,0, 0,-1,0, 0,0,-1, 1,1,1), time = 7)
			effected += M

		sleep(3)

		for(var/atom/M in effected)
			spawn()
				animate(M, color = null, time = 3)
			spawn()
				animate(M, color = list(0.6,0,0.1, 0,0.6,0.1, 0,0,0.7, 0,0,0), time = 3)

		sleep(6)

		for(var/atom/M in effected)
			spawn()
				animate(M, color = null, time = 3)

		effected = list()

	proc/releaseDomain(mob/user, atom/center)
		if(!user)
			return

		if(user.getCursedEnergySecret() && !user.BuffOn(src) && user.ManaAmount < 30)
			user << "You need at least 30 Cursed Energy to open your Domain."
			return

		if(!center)
			center = user

		src.Trigger(user)

		if(user.BuffOn(src))
			animation(center, range)
			user.DomainExpansion(src, center)
		else
			user.stopDomainExapansion()
			if(src.Cooldown < 200)
				src.Cooldown = 200


	GainLoop(mob/source)
		var/was_active = source && source.BuffOn(src)
		..()
		if(was_active && source && !source.BuffOn(src) && source.domainExpansionActive)
			source.stopDomainExapansion()
			if(!src.cooldown_remaining)
				var/oldCooldown = src.Cooldown
				src.Cooldown = 200
				src.Cooldown(p = source)
				src.Cooldown = oldCooldown

	verb/Domain_Expansion_Wide()
		set category = "Skills"
		set name = "Domain Expansion Wide"
		releaseDomain(usr, usr)

	verb/Domain_Expansion_Target()
		set category = "Skills"
		set name = "Domain Expansion Target"

		if(!usr.Target || usr.Target == usr)
			usr << "You need a target for Domain Expansion Target."
			return

		releaseDomain(usr, usr.Target)


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
	Slotless = 1
	TimerLimit = 4
	Cooldown = 100
	CooldownStatic = 1
	BuffName = "Hollow Wicker Basket"
	var/tmp/restores_movement = FALSE
	passives = list("PureReduction" = 9999)
	IconLock = 'HolyDome_Wicker_Shimmer.dmi'
	LockX = -158
	LockY = -96
	ActiveMessage = "forms Hollow Wicker Basket, a woven barrier distorting the space around them."
	OffMessage = "releases the barrier around them."


/obj/Skills/Buffs/SlotlessBuffs/Domain_Lock
	name = "Domain Lock"
	TimerLimit = 0


/obj/Skills/Buffs/SlotlessBuffs/Dividing_Driver
	name = "Dividing Driver"


/obj/Skills/Buffs/SlotlessBuffs/Domain_Expansion/Cursed_Energy
	ManaDrain = 2
	ManaThreshold = 1
	BuffName = "Domain Expansion Unleashed!"
	Mastery = -1
	UnrestrictedBuff = 1
	StrMult = 1.50
	ForMult = 1.50
	EndMult = 1.50
	SpdMult = 1.50
	DefMult = 1.50
	OffMult = 1.50
	MakesArmor = 0
	TurfShift = 'WhiteTurfShift.dmi'
	TurfShiftInstant = 1
	passives = list("TechniqueMastery" = 5, "BuffMastery" = 2, "MovementMastery" = 5)
	DarkChange = 1