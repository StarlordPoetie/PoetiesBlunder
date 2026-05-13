/obj/Skills/Buffs/SlotlessBuffs/Autonomous/QueueBuff/Cursed_Energy_Maximum_Output
	BuffName = "Cursed Energy Maximum Output"
	Mastery = -1
	UnrestrictedBuff = 1
	StrMult = 1.20
	ForMult = 1.20
	EndMult = 1.20
	SpdMult = 1.20
	DefMult = 1.20
	OffMult = 1.20
	MakesArmor = 0
	TurfShift = 'WhiteTurfShift.dmi'
	TurfShiftInstant = 1
	TimerLimit = 90
	passives = list("TechniqueMastery" = 5, "BuffMastery" = 2, "MovementMastery" = 5)
	FlashChange = 1
	ActiveMessage = "surges into Cursed Energy Maximum Output!"
	OffMessage = "lets their Maximum Output fade."
	CursedTechnique = 1

/obj/Skills/Buffs/SlotlessBuffs/Domain_Expansion/Cursed_Energy
	BuffName = "Domain Expansion Unleashed!"
	Mastery = -1
	CursedTechnique = 1
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
	ManaDrain = 2
	ManaThreshold = 1
	TimerLimit = 200
	passives = list("TechniqueMastery" = 5, "BuffMastery" = 2, "MovementMastery" = 5)
	DarkChange = 1
	Range = 15
	range = 15
	SkillCost = 0
	Copyable = 0

/obj/Skills/Queue/Cursed_Energy_Black_Flash_Strike
	name = "Cursed Energy Black Flash"
	CursedTechnique = 1
	SkillCost = 0
	Copyable = 0
	Cooldown = 15
	Duration = 4
	TextColor = "#5B189A"
	ActiveMessage = "draws cursed force into a black spark...!"
	HitMessage = "lands a cursed impact wreathed in black sparks!"
	DamageMult = (2 ** 2.5)
	AccuracyMult = 10
	KBAdd = 10
	PushOut = 2
	PushOutWaves = 3
	PushOutIcon = 'DarkKiai.dmi'
	HitSparkIcon = 'Black_Flash_Hitspark_1.dmi'
	HitSparkX = -14
	HitSparkY = -12
	HitSparkTurns = 1
	HitSparkSize = 4
	KBMult = 10
	adjust(mob/p)
		if(!p || !p.hasCursedEnergy()) return
		p.cursedEnergyGainMaximumOutput(maxOutputGainCursedBlackFlash)
		if(p.cursedEnergySparksOfBlack)
			if(prob(50))
				p.OMessage(10, "Black sparks cling to [p]'s cursed rhythm!", "<font color=purple>[p] retained Cursed Energy momentum.</font>")
			else
				p.cursedEnergyBlackFlashChance = p.cursedEnergyBlackFlashBaseChance
		else
			p.cursedEnergyBlackFlashChance = p.cursedEnergyBlackFlashBaseChance

/obj/Skills/Queue/Cursed_Energy_Divergent_Fist
	name = "Cursed Energy Divergent Fist"
	CursedTechnique = 1
	SkillCost = 0
	Copyable = 0
	Cooldown = 15
	Duration = 5
	ActiveMessage = "lets cursed force lag behind their fist...!"
	HitMessage = "strikes twice as cursed force follows after the blow!"
	DamageMult = 2
	HitSparkIcon = 'CE Hitspark.dmi'
	HitSparkTurns = 1
	HitSparkSize = 1
	AccuracyMult = 1
	KBAdd = 5
	KBMult = 3
	adjust(mob/p)
		if(!p || !p.hasCursedEnergy()) return
		p.cursedEnergyBlackFlashChance = clamp(p.cursedEnergyBlackFlashChance + 5, p.cursedEnergyBlackFlashBaseChance, 35)

/obj/Skills/Queue/Cursed_Technique_Gamblers_Fist
	name = "Cursed Technique: Gambler's Fist"
	CursedTechnique = 1
	SkillCost = 0
	Copyable = 0
	DamageMult = 3
	AccuracyMult = 1.25
	Cooldown = 20
	Duration = 5
	HitSparkIcon = 'CE Hitspark.dmi'
	HitMessage = "bets it all on a jagged cursed strike!"

/obj/Skills/AutoHit/Shutter_Doors
	name = "Shutter Doors"
	CursedTechnique = 1
	SkillCost = 0
	Copyable = 0
	DamageMult = 2.5
	AccuracyMult = 1.2
	Cooldown = 30
	Range = 8
	Area = "Circle"
	StrOffense = 1
	ActiveMessage = "slams serrated cursed shutters shut!"

/obj/Skills/AutoHit/Cursed_Voltage_Strike
	name = "Cursed Voltage Strike"
	CursedTechnique = 1
	SkillCost = 0
	Copyable = 0
	DamageMult = 3
	AccuracyMult = 1.25
	Cooldown = 25
	Range = 6
	Shocking = 10
	Paralyzing = 2
	StrOffense = 1
	ActiveMessage = "lashes out with electrified Cursed Energy!"

/obj/Skills/Projectile/Cursed_Technique_Dismantle
	name = "Cursed Technique: Dismantle"
	CursedTechnique = 1
	SkillCost = 0
	Copyable = 0
	DamageMult = 3
	AccuracyMult = 1.2
	Cooldown = 20
	IconLock = 'CE Hitspark.dmi'
	Distance = 25
	Speed = 1
	Shearing = 5
	StrOffense = 1
	ActiveMessage = "flicks out a dismantling slash of Cursed Energy!"

/obj/Skills/AutoHit/Cursed_Technique_Cleave
	name = "Cursed Technique: Cleave"
	CursedTechnique = 1
	SkillCost = 0
	Copyable = 0
	DamageMult = 4.5
	AccuracyMult = 1.25
	Cooldown = 35
	Range = 5
	Shearing = 8
	StrOffense = 1
	ActiveMessage = "adjusts a cursed slash to cleave through their target!"

/obj/Skills/Buffs/SlotlessBuffs/Limitless
	BuffName = "Limitless"
	CursedTechnique = 1
	SkillCost = 0
	Copyable = 0
	Mastery = -1
	UnrestrictedBuff = 1
	TimerLimit = 120
	passives = list("Deflection" = 2, "Flow" = 2, "Instinct" = 2)
	ActiveMessage = "wraps themselves in the Limitless."
	OffMessage = "lets the Limitless fall away."

/obj/Skills/AutoHit/Cursed_Technique_Red
	name = "Cursed Technique: Red"
	CursedTechnique = 1
	SkillCost = 0
	Copyable = 0
	DamageMult = 4
	AccuracyMult = 1.4
	Cooldown = 45
	Range = 10
	KBAdd = 15
	KBMult = 4
	ForOffense = 1
	ActiveMessage = "erupts with a repulsive red singularity!"

/obj/Skills/AutoHit/Cursed_Technique_Blue
	name = "Cursed Technique: Blue"
	CursedTechnique = 1
	SkillCost = 0
	Copyable = 0
	DamageMult = 2.5
	AccuracyMult = 1.3
	Cooldown = 35
	Range = 10
	Attracting = 1
	ForOffense = 1
	ActiveMessage = "pulls space inward with a blue singularity!"

/obj/Skills/Projectile/Cursed_Technique_Hollow_Purple
	name = "Cursed Technique: Hollow Purple"
	CursedTechnique = 1
	SkillCost = 0
	Copyable = 0
	DamageMult = 7
	AccuracyMult = 1.5
	Cooldown = 120
	IconLock = 'CE Hitspark.dmi'
	Distance = 30
	Speed = 1
	Piercing = 1
	ForOffense = 1
	ActiveMessage = "combines attraction and repulsion into Hollow Purple!"
	adjust(mob/p)
		if(p && p.maxOutputActive) p.consumeCursedEnergyMaximumOutput()

/obj/Skills/Buffs/SlotlessBuffs/Disaster_Flames
	BuffName = "Disaster Flames"
	CursedTechnique = 1
	SkillCost = 0
	Copyable = 0
	Mastery = -1
	UnrestrictedBuff = 1
	TimerLimit = 120
	passives = list("Scorching" = 3, "Burning" = 2, "PureDamage" = 0.5)
	ActiveMessage = "erupts in disaster flames!"
	OffMessage = "lets the disaster flames gutter out."

/obj/Skills/AutoHit/Cursed_Technique_Volcanic_Strike
	name = "Cursed Technique: Volcanic Strike"
	CursedTechnique = 1
	SkillCost = 0
	Copyable = 0
	DamageMult = 4
	AccuracyMult = 1.25
	Cooldown = 35
	Range = 8
	Scorching = 10
	Burning = 4
	ForOffense = 1
	ActiveMessage = "detonates volcanic Cursed Energy!"

/obj/Skills/Projectile/Cursed_Technique_Maximum_Meteor
	name = "Cursed Technique: Maximum Meteor"
	CursedTechnique = 1
	SkillCost = 0
	Copyable = 0
	DamageMult = 8
	AccuracyMult = 1.35
	Cooldown = 150
	IconLock = 'CE Hitspark.dmi'
	Distance = 30
	Speed = 1
	Scorching = 20
	Shattering = 10
	ForOffense = 1
	ActiveMessage = "calls down a catastrophic Maximum Meteor!"
	adjust(mob/p)
		if(p && p.maxOutputActive) p.consumeCursedEnergyMaximumOutput()

/obj/Skills/proc/validateCursedDomainSureHit(mob/p, trait)
	if(!p || !p.hasCursedEnergy())
		if(p) p << "Only Cursed Energy users can invoke this sure-hit."
		return 0
	if(p.cursedEnergyTrait != trait)
		p << "This sure-hit does not match your Cursed Energy trait."
		return 0
	if(!p.hasActiveCursedEnergyDomain())
		p << "You must have an active Cursed Energy Domain Expansion to use this sure-hit."
		return 0
	return 1

/obj/Skills/Buffs/SlotlessBuffs/Cursed_Domain_Gamblers_Luck
	BuffName = "Cursed Domain: Gambler's Luck"
	CursedTechnique = 1
	SkillCost = 0
	Copyable = 0
	Mastery = -1
	UnrestrictedBuff = 1
	TimerLimit = 30
	passives = list("CriticalChance" = 25, "CriticalDamage" = 5)
	ActiveMessage = "loads their Domain with Gambler's Luck!"
	OffMessage = "spends the last of Gambler's Luck."
	verb/Cursed_Domain_Gamblers_Luck()
		set category = "Skills"
		if(!src.validateCursedDomainSureHit(usr, "Serrated")) return
		src.Trigger(usr)
		usr.collapseCursedEnergyDomain(src)

/obj/Skills/AutoHit/Cursed_Domain_Dismantle
	name = "Cursed Domain: Dismantle"
	CursedTechnique = 1
	SkillCost = 0
	Copyable = 0
	DamageMult = 6
	AccuracyMult = 10
	Cooldown = 120
	Range = 15
	Shearing = 15
	StrOffense = 1
	verb/Cursed_Domain_Dismantle()
		set category = "Skills"
		if(!src.validateCursedDomainSureHit(usr, "Slash")) return
		usr.Activate(src)
		usr.collapseCursedEnergyDomain(src)

/obj/Skills/AutoHit/Cursed_Domain_Electric_Discharge
	name = "Cursed Domain: Electric Discharge"
	CursedTechnique = 1
	SkillCost = 0
	Copyable = 0
	DamageMult = 5
	AccuracyMult = 10
	Cooldown = 120
	Range = 15
	Shocking = 20
	Paralyzing = 5
	ForOffense = 1
	verb/Cursed_Domain_Electric_Discharge()
		set category = "Skills"
		if(!src.validateCursedDomainSureHit(usr, "Electricity")) return
		usr.Activate(src)
		usr.collapseCursedEnergyDomain(src)

/obj/Skills/AutoHit/Cursed_Domain_Infinite_Void
	name = "Cursed Domain: Infinite Void"
	CursedTechnique = 1
	SkillCost = 0
	Copyable = 0
	DamageMult = 4
	AccuracyMult = 10
	Cooldown = 120
	Range = 15
	Stunner = 5
	ForOffense = 1
	verb/Cursed_Domain_Infinite_Void()
		set category = "Skills"
		if(!src.validateCursedDomainSureHit(usr, "Spatial Manipulation")) return
		usr.Activate(src)
		usr.collapseCursedEnergyDomain(src)
