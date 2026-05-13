#define CURSED_ENERGY_TRAITS list("Serrated", "Electricity", "Slash", "Spatial Manipulation", "Immolation")
#define CURSED_ENERGY_SPECIALIZATIONS list("Cursed Energy Reinforcement", "Cursed Energy Enrichment", "Cursed Energy Enhancement")
#define CURSED_ENERGY_ANTI_DOMAIN list("Simple Domain", "Hollow Wicker Basket")

var/global/list/cursedEnergyTraitReservations = list()
var/global/maxOutputEnabled = 1
var/global/maxOutputGaugeMax = 100
var/global/maxOutputGainOnHit = 4
var/global/maxOutputGainOnDamageTaken = 2.5
var/global/maxOutputGainCursedBlackFlash = 35
var/global/maxOutputDecayRate = 0

/obj/Skills/var/CursedTechnique = 0

/mob/var
	cursedEnergyAuraColor
	cursedEnergyTrait
	cursedEnergySpecialization
	cursedEnergyDomainChoice
	cursedEnergyTraitSlot
	cursedEnergyPoseHealReady = 0
	cursedEnergyPoseHealCooldown = 0
	cursedEnergySixEyes = 0
	cursedEnergySixEyesOverlay
	cursedEnergyInfiniteVoidEscapes = 0
	cursedEnergyTraitPassivesApplied = 0
	cursedEnergySpecializationPassivesApplied = 0
	cursedEnergyBlackFlashChance = 0
	cursedEnergyBlackFlashBaseChance = 0
	cursedEnergyBlackFlashForcedChance = 0
	cursedEnergyBlackFlashFirstUse = 1
	cursedEnergySparksOfBlack = 0
	cursedEnergyPowerControlIcon
	cursedEnergyPowerControlState
	cursedEnergyPowerControlPixelX = 0
	cursedEnergyPowerControlPixelY = 0
	cursedEnergyPowerControlStored = 0
	maxOutputGauge = 0
	maxOutputGaugeMax = 100
	maxOutputActive = 0

/proc/cursedEnergyTraitOwner(mob/p)
	if(!p) return null
	if(p.ckey) return p.ckey
	if(p.key) return p.key
	return "[p]"

/proc/cursedEnergyTraitPassives(trait)
	switch(trait)
		if("Electricity") return list("Shocking" = 2, "ThunderHerald" = 1, "CriticalChance" = 10)
		if("Slash") return list("Shearing" = 2, "Crippling" = 1, "CriticalChance" = 15)
		if("Serrated") return list("Shearing" = 2, "Shattering" = 2, "CriticalChance" = 10)
		if("Spatial Manipulation") return list("Flow" = 2, "Instinct" = 2, "Deflection" = 1)
		if("Immolation") return list("Scorching" = 4, "Burning" = 2, "PureDamage" = 0.5)
	return list()

/proc/cursedEnergySpecializationPassives(spec)
	switch(spec)
		if("Cursed Energy Reinforcement") return list("Cursed Energy Reinforcement" = 1, "UnarmedDamage" = 3, "CriticalDamage" = 2, "CriticalChance" = 2, "CriticalBlock" = 2, "PureReduction" = 2, "Flow" = 4, "Adrenaline" = 3, "Fury" = 2)
		if("Cursed Energy Enrichment") return list("Cursed Energy Enrichment" = 1, "Adrenaline" = 3, "MeleeResist" = 2, "ManaSteal" = 20, "ManaGeneration" = 3, "PowerfulCasting" = 2, "StalwartCasting" = 2, "FluidForm" = 3, "Fury" = 2)
		if("Cursed Energy Enhancement") return list("Cursed Energy Enhancement" = 1, "Fury" = 2, "Parry" = 2, "Reversal" = 2, "Instinct" = 4, "SwordDamage" = 2, "Adrenaline" = 3, "SwordAscension" = 1)
	return list()

/proc/cursedEnergySkillPaths()
	return list(/obj/Skills/Queue/Cursed_Energy_Black_Flash_Strike, /obj/Skills/Queue/Cursed_Energy_Divergent_Fist, /obj/Skills/Queue/Cursed_Technique_Gamblers_Fist, /obj/Skills/AutoHit/Shutter_Doors, /obj/Skills/AutoHit/Cursed_Voltage_Strike, /obj/Skills/Projectile/Cursed_Technique_Dismantle, /obj/Skills/AutoHit/Cursed_Technique_Cleave, /obj/Skills/Buffs/SlotlessBuffs/Limitless, /obj/Skills/AutoHit/Cursed_Technique_Red, /obj/Skills/AutoHit/Cursed_Technique_Blue, /obj/Skills/Projectile/Cursed_Technique_Hollow_Purple, /obj/Skills/Buffs/SlotlessBuffs/Disaster_Flames, /obj/Skills/AutoHit/Cursed_Technique_Volcanic_Strike, /obj/Skills/Projectile/Cursed_Technique_Maximum_Meteor, /obj/Skills/Buffs/SlotlessBuffs/Autonomous/QueueBuff/Cursed_Energy_Maximum_Output, /obj/Skills/Buffs/SlotlessBuffs/Domain_Expansion/Cursed_Energy, /obj/Skills/Buffs/SlotlessBuffs/Cursed_Domain_Gamblers_Luck, /obj/Skills/AutoHit/Cursed_Domain_Dismantle, /obj/Skills/AutoHit/Cursed_Domain_Electric_Discharge, /obj/Skills/AutoHit/Cursed_Domain_Infinite_Void)

/mob/proc/hasCursedEnergy()
	return hasSecret("Cursed Energy") && istype(secretDatum, /SecretInformation/CursedEnergy)

/mob/proc/cursedEnergyReserveTrait(trait)
	if(!(trait in CURSED_ENERGY_TRAITS)) return 0
	var/owner = cursedEnergyTraitOwner(src)
	var/current = cursedEnergyTraitReservations[trait]
	if(current && current != owner) return 0
	cursedEnergyTraitReservations[trait] = owner
	cursedEnergyTraitSlot = trait
	return 1

/mob/proc/cursedEnergyFreeTraitSlot()
	if(cursedEnergyTraitSlot && cursedEnergyTraitReservations[cursedEnergyTraitSlot] == cursedEnergyTraitOwner(src))
		cursedEnergyTraitReservations -= cursedEnergyTraitSlot
	cursedEnergyTraitSlot = null

/mob/proc/cursedEnergyPickTrait()
	var/list/available = list()
	for(var/trait in CURSED_ENERGY_TRAITS)
		var/current = cursedEnergyTraitReservations[trait]
		if(!current || current == cursedEnergyTraitOwner(src)) available += trait
	if(!available.len) return null
	return pick(available)

/mob/proc/cursedEnergyAddSkill(path)
	if(!path) return null
	for(var/obj/Skills/S in src.Skills)
		if(S.type == path) return S
	var/obj/Skills/N = new path
	N.Copyable = 0
	AddSkill(N)
	return N

/mob/proc/cursedEnergyRemoveSkills()
	var/list/paths = cursedEnergySkillPaths()
	for(var/obj/Skills/S in src.Skills.Copy())
		if(S.type in paths)
			DeleteSkill(S)

/mob/proc/cursedEnergyStorePowerControl()
	for(var/obj/Skills/Power_Control/P in src)
		if(!cursedEnergyPowerControlStored)
			cursedEnergyPowerControlIcon = P.sicon
			cursedEnergyPowerControlState = P.sicon_state
			cursedEnergyPowerControlPixelX = P.pixel_x
			cursedEnergyPowerControlPixelY = P.pixel_y
			cursedEnergyPowerControlStored = 1
		P.sicon = 'Cursed Energy - Divergent Fist W GLOW.dmi'
		P.sicon_state = null
		P.pixel_x = 0
		P.pixel_y = 0

/mob/proc/cursedEnergyRestorePowerControl()
	if(!cursedEnergyPowerControlStored) return
	for(var/obj/Skills/Power_Control/P in src)
		P.sicon = cursedEnergyPowerControlIcon
		P.sicon_state = cursedEnergyPowerControlState
		P.pixel_x = cursedEnergyPowerControlPixelX
		P.pixel_y = cursedEnergyPowerControlPixelY
	cursedEnergyPowerControlIcon = null
	cursedEnergyPowerControlState = null
	cursedEnergyPowerControlPixelX = 0
	cursedEnergyPowerControlPixelY = 0
	cursedEnergyPowerControlStored = 0

/mob/proc/applyCursedEnergyTraitPassives()
	if(!hasCursedEnergy() || cursedEnergyTraitPassivesApplied || !cursedEnergyTrait) return
	passive_handler.Increase(cursedEnergyTraitPassives(cursedEnergyTrait))
	cursedEnergyTraitPassivesApplied = 1

/mob/proc/removeCursedEnergyTraitPassives()
	if(!cursedEnergyTraitPassivesApplied || !cursedEnergyTrait) return
	passive_handler.Decrease(cursedEnergyTraitPassives(cursedEnergyTrait))
	cursedEnergyTraitPassivesApplied = 0

/mob/proc/applyCursedEnergySpecializationPassives()
	if(!hasCursedEnergy() || cursedEnergySpecializationPassivesApplied || !cursedEnergySpecialization) return
	passive_handler.Increase(cursedEnergySpecializationPassives(cursedEnergySpecialization))
	cursedEnergySpecializationPassivesApplied = 1

/mob/proc/removeCursedEnergySpecializationPassives()
	if(!cursedEnergySpecializationPassivesApplied || !cursedEnergySpecialization) return
	passive_handler.Decrease(cursedEnergySpecializationPassives(cursedEnergySpecialization))
	cursedEnergySpecializationPassivesApplied = 0

/mob/proc/cursedEnergyTraitSkillPaths()
	switch(cursedEnergyTrait)
		if("Serrated") return list(/obj/Skills/Queue/Cursed_Technique_Gamblers_Fist, /obj/Skills/AutoHit/Shutter_Doors)
		if("Electricity") return list(/obj/Skills/AutoHit/Cursed_Voltage_Strike)
		if("Slash") return list(/obj/Skills/Projectile/Cursed_Technique_Dismantle, /obj/Skills/AutoHit/Cursed_Technique_Cleave)
		if("Spatial Manipulation") return list(/obj/Skills/Buffs/SlotlessBuffs/Limitless, /obj/Skills/AutoHit/Cursed_Technique_Red, /obj/Skills/AutoHit/Cursed_Technique_Blue, /obj/Skills/Projectile/Cursed_Technique_Hollow_Purple)
		if("Immolation") return list(/obj/Skills/Buffs/SlotlessBuffs/Disaster_Flames, /obj/Skills/AutoHit/Cursed_Technique_Volcanic_Strike, /obj/Skills/Projectile/Cursed_Technique_Maximum_Meteor)
	return list()

/mob/proc/grantCursedEnergyTraitSkills()
	for(var/path in cursedEnergyTraitSkillPaths())
		cursedEnergyAddSkill(path)
	if(cursedEnergyTrait == "Slash")
		passive_handler.Set("BladeFisting", 1)
		var/scale = 1 + (0.5 * max(0, getSecretLevel() - 1))
		for(var/obj/Skills/Projectile/Cursed_Technique_Dismantle/D in src) D.DamageMult = 3 * scale
		for(var/obj/Skills/AutoHit/Cursed_Technique_Cleave/C in src) C.DamageMult = 4.5 * scale
	if(cursedEnergyTrait == "Spatial Manipulation" && !cursedEnergySixEyes && prob(10))
		cursedEnergySixEyes = 1
		OMessage(10, "[src]'s eyes flare with impossible clarity.", "<font color=cyan>[src] awakened Six Eyes.</font>")

/mob/proc/cursedEnergySixEyesActive()
	return hasCursedEnergy() && cursedEnergySixEyes && cursedEnergyTrait == "Spatial Manipulation"

/mob/proc/cursedEnergyManaCostReduction(obj/Skills/S)
	if(!S || !S.CursedTechnique || !hasCursedEnergy()) return 0
	var/reduction = min(0.4, max(0, getSecretLevel() - 1) * 0.1)
	if(cursedEnergySixEyesActive()) reduction += 0.35
	return min(reduction, 0.75)

/mob/proc/cursedEnergyGainMaximumOutput(amount)
	if(!maxOutputEnabled || !hasCursedEnergy() || maxOutputActive) return
	if(!src.maxOutputGaugeMax) src.maxOutputGaugeMax = 100
	maxOutputGauge = clamp(maxOutputGauge + amount, 0, src.maxOutputGaugeMax)
	if(maxOutputGauge >= src.maxOutputGaugeMax)
		activateCursedEnergyMaximumOutput()
	if(hascall(src, "updateCursedEnergyMaximumOutputHUD")) call(src, "updateCursedEnergyMaximumOutputHUD")()

/mob/proc/activateCursedEnergyMaximumOutput()
	if(!hasCursedEnergy()) return
	var/obj/Skills/Buffs/SlotlessBuffs/Autonomous/QueueBuff/Cursed_Energy_Maximum_Output/B = cursedEnergyAddSkill(/obj/Skills/Buffs/SlotlessBuffs/Autonomous/QueueBuff/Cursed_Energy_Maximum_Output)
	if(B && !BuffOn(B)) B.Trigger(src, Override = 1)
	maxOutputActive = 1

/mob/proc/consumeCursedEnergyMaximumOutput()
	for(var/obj/Skills/Buffs/SlotlessBuffs/Autonomous/QueueBuff/Cursed_Energy_Maximum_Output/B in src)
		if(BuffOn(B)) B.Trigger(src, Override = 1)
	maxOutputGauge = 0
	maxOutputActive = 0
	if(hascall(src, "updateCursedEnergyMaximumOutputHUD")) call(src, "updateCursedEnergyMaximumOutputHUD")()

/mob/proc/grantCursedEnergyDomain()
	var/obj/Skills/Buffs/SlotlessBuffs/Domain_Expansion/Cursed_Energy/D = cursedEnergyAddSkill(/obj/Skills/Buffs/SlotlessBuffs/Domain_Expansion/Cursed_Energy)
	if(!D) return
	if(!D.demonName)
		D.demonName = input(src, "Name your Domain Expansion.", "Cursed Energy Domain") as text|null
		if(!D.demonName) D.demonName = "Innate Domain"
		var/icon/domainFloor = input(src, "Upload a custom floor/turf icon, or cancel to use the default.", "Cursed Energy Domain") as icon|null
		D.customTurfIcon = domainFloor ? domainFloor : 'WhiteTurfShift.dmi'
		var/shroud = input(src, "Use a shroud overlay?", "Cursed Energy Domain") in list("Yes", "No")
		D.useShroud = (shroud == "Yes")
		if(D.useShroud)
			var/icon/domainShroud = input(src, "Upload a custom shroud icon, or cancel for the default shroud.", "Cursed Energy Domain") as icon|null
			D.customRoofIcon = domainShroud
	D.range = 15
	D.ActiveMessage = "says: Domain Expansion.. [D.demonName]!"
	D.OffMessage = "conceals the domain of [D.demonName]..."
	if(!cursedEnergyDomainChoice)
		cursedEnergyDomainChoice = input(src, "Choose your anti-domain technique.", "Cursed Energy Domain") in CURSED_ENERGY_ANTI_DOMAIN
	grantCursedEnergyDomainSureHit()

/mob/proc/grantCursedEnergyDomainSureHit()
	if(!locate(/obj/Skills/Buffs/SlotlessBuffs/Domain_Expansion/Cursed_Energy, src)) return
	switch(cursedEnergyTrait)
		if("Serrated") cursedEnergyAddSkill(/obj/Skills/Buffs/SlotlessBuffs/Cursed_Domain_Gamblers_Luck)
		if("Slash") cursedEnergyAddSkill(/obj/Skills/AutoHit/Cursed_Domain_Dismantle)
		if("Electricity") cursedEnergyAddSkill(/obj/Skills/AutoHit/Cursed_Domain_Electric_Discharge)
		if("Spatial Manipulation") cursedEnergyAddSkill(/obj/Skills/AutoHit/Cursed_Domain_Infinite_Void)

/mob/proc/hasActiveCursedEnergyDomain()
	if(!hasCursedEnergy() || !domainExpansionActive) return 0
	var/obj/Skills/Buffs/SlotlessBuffs/Domain_Expansion/Cursed_Energy/D = locate() in src
	return D && BuffOn(D)

/mob/proc/collapseCursedEnergyDomain(obj/Skills/used)
	var/obj/Skills/Buffs/SlotlessBuffs/Domain_Expansion/Cursed_Energy/D = locate() in src
	if(D && BuffOn(D)) D.Trigger(src, Override = 1)
	if(domainExpansionActive) stopDomainExapansion()
	if(D) D.Cooldown()
	if(used) used.Cooldown()

/mob/proc/attemptCursedHeavyStrike()
	if(!hasCursedEnergy()) return 0
	if(!canCursedEnergyHeavyStrike()) return 1
	var/obj/Skills/Queue/strike = getCursedEnergyHeavyStrike()
	if(!strike) return 0
	if(strike.Using) return 1
	strike.adjust(src)
	SetQueue(strike)
	return 1

/mob/proc/canCursedEnergyHeavyStrike()
	for(var/obj/Skills/Queue/Heavy_Strike/hs in src) if(hs.Using) return 0
	for(var/obj/Skills/Queue/Cursed_Energy_Black_Flash_Strike/bf in src) if(bf.Using) return 0
	for(var/obj/Skills/Queue/Cursed_Energy_Divergent_Fist/df in src) if(df.Using) return 0
	return 1

/mob/proc/getCursedEnergyHeavyStrike()
	var/rollChance = cursedEnergyBlackFlashForcedChance ? cursedEnergyBlackFlashForcedChance : cursedEnergyBlackFlashChance
	rollChance = clamp(rollChance, cursedEnergyBlackFlashBaseChance, 35)
	cursedEnergyBlackFlashChance = rollChance
	if(prob(rollChance)) return cursedEnergyAddSkill(/obj/Skills/Queue/Cursed_Energy_Black_Flash_Strike)
	return cursedEnergyAddSkill(/obj/Skills/Queue/Cursed_Energy_Divergent_Fist)

/mob/proc/attemptCursedToss(obj/Skills/Grapple/Toss/Z)
	if(!hasCursedEnergy()) return 0
	if(cursedEnergyTrait == "Spatial Manipulation")
		for(var/obj/Skills/AutoHit/Cursed_Technique_Blue/B in src)
			Activate(B)
			if(Z) Z.Cooldown(3)
			return 1
	return 0

/mob/proc/attemptCursedReverseDash()
	if(!hasCursedEnergy() || !cursedEnergyDomainChoice) return 0
	OMessage(10, "[src] answers with [cursedEnergyDomainChoice]!", "<font color=cyan>[src] used [cursedEnergyDomainChoice].</font>")
	return 1

/mob/proc/activateReversedCursedTechnique()
	if(!hasCursedEnergy()) return 0
	if(!cursedEnergyPoseHealReady)
		src << "You are not prepared to reverse your Cursed Energy."
		return 1
	if(world.time < cursedEnergyPoseHealCooldown)
		src << "Reversed Curse Technique is still cooling down."
		return 1
	var/list/heals = list(8, 9.5, 11, 12.5, 14)
	var/heal = heals[clamp(getSecretLevel(), 1, 5)]
	if(cursedEnergySixEyesActive()) heal *= 2
	HealthCut = 0
	TotalInjury = 0
	Maimed = 0
	MortallyWounded = 0
	for(var/obj/Skills/Buffs/SlotlessBuffs/Autonomous/Debuff/D in src) DeleteSkill(D)
	HealHealth(heal)
	HealMana(50)
	ManaMax += 50
	cursedEnergyPoseHealReady = 0
	cursedEnergyPoseHealCooldown = world.time + 300
	OMessage(10, "[src] converts cursed force into life with Reversed Curse Technique!", "<font color=cyan>[src] used Reversed Curse Technique.</font>")
	return 1

/mob/proc/cleanupCursedEnergy()
	removeCursedEnergyTraitPassives()
	removeCursedEnergySpecializationPassives()
	cursedEnergyRestorePowerControl()
	passive_handler.Decrease(list("RenameMana" = "Cursed Energy"))
	passive_handler.Set("Cursed Energy Sparks of Black", 0)
	if(cursedEnergyTrait == "Slash") passive_handler.Set("BladeFisting", 0)
	var/obj/Skills/Buffs/SlotlessBuffs/Domain_Expansion/Cursed_Energy/D = locate() in src
	if(D && BuffOn(D)) D.Trigger(src, Override = 1)
	if(domainExpansionActive) stopDomainExapansion()
	cursedEnergyRemoveSkills()
	cursedEnergyFreeTraitSlot()
	cursedEnergyAuraColor = null
	cursedEnergyTrait = null
	cursedEnergySpecialization = null
	cursedEnergyDomainChoice = null
	cursedEnergyPoseHealReady = 0
	cursedEnergyPoseHealCooldown = 0
	cursedEnergySixEyes = 0
	cursedEnergySixEyesOverlay = null
	cursedEnergyInfiniteVoidEscapes = 0
	cursedEnergyTraitPassivesApplied = 0
	cursedEnergySpecializationPassivesApplied = 0
	cursedEnergyBlackFlashChance = 0
	cursedEnergyBlackFlashBaseChance = 0
	cursedEnergyBlackFlashForcedChance = 0
	cursedEnergyBlackFlashFirstUse = 1
	cursedEnergySparksOfBlack = 0
	maxOutputGauge = 0
	maxOutputGaugeMax = 100
	maxOutputActive = 0
	if(istype(secretDatum, /SecretInformation/CursedEnergy))
		Secret = null
		secretDatum = new /SecretInformation()
	AdminMessage("[src]'s Cursed Energy secret was cleaned up.")

/SecretInformation/CursedEnergy
	name = "Cursed Energy"
	maxTier = 5
	givenSkills = list()

	applySecret(mob/p)
		if(!p) return
		if(!p.cursedEnergyTrait)
			var/chosenTrait = p.cursedEnergyPickTrait()
			if(!chosenTrait || !p.cursedEnergyReserveTrait(chosenTrait))
				p << "No Cursed Energy trait slots are available. Cursed Energy was not applied."
				return
			p.cursedEnergyTrait = chosenTrait
			p.cursedEnergyAuraColor = input(p, "Choose the color of your Cursed Energy aura.", "Cursed Energy") as color|null
			p << "Your Cursed Energy manifests as [chosenTrait]."
		else if(!p.cursedEnergyReserveTrait(p.cursedEnergyTrait))
			p << "Your stored Cursed Energy trait is currently reserved by someone else. Cursed Energy could not refresh."
			return
		p.Secret = "Cursed Energy"
		p.secretDatum = src
		if(p.passive_handler.Get("RenameMana") != "Cursed Energy") p.passive_handler.Increase(list("RenameMana" = "Cursed Energy"))
		p.cursedEnergyStorePowerControl()
		p.maxOutputGaugeMax = maxOutputGaugeMax
		p.cursedEnergyBlackFlashBaseChance = clamp(5 + ((currentTier - 1) * 7.5), 5, 35)
		p.cursedEnergyBlackFlashChance = clamp(max(p.cursedEnergyBlackFlashChance, p.cursedEnergyBlackFlashBaseChance), p.cursedEnergyBlackFlashBaseChance, 35)
		p.applyCursedEnergyTraitPassives()
		p.grantCursedEnergyTraitSkills()
		p.cursedEnergyAddSkill(/obj/Skills/Buffs/SlotlessBuffs/Autonomous/QueueBuff/Cursed_Energy_Maximum_Output)
		switch(currentTier)
			if(1)
				p.cursedEnergyPoseHealReady = 1
				p << "Cursed Energy awakens within you."
				if(prob(10)) p.grantCursedEnergyDomain()
			if(2)
				p.cursedEnergySparksOfBlack = 1
				p.passive_handler.Set("Cursed Energy Sparks of Black", 1)
				if(!p.cursedEnergySpecialization)
					p.cursedEnergySpecialization = input(p, "Choose a Cursed Energy specialization.", "Cursed Energy") in CURSED_ENERGY_SPECIALIZATIONS
				p.applyCursedEnergySpecializationPassives()
				p << "Your Cursed Energy control sharpens."
				if(prob(20)) p.grantCursedEnergyDomain()
			if(3)
				p << "Your Cursed Energy density and precision deepen."
				if(prob(35)) p.grantCursedEnergyDomain()
			if(4)
				p << "Your innate domain becomes ready to unleash."
				p.grantCursedEnergyDomain()
			if(5)
				p << "Your mastery over your Domain Expansion improves."
				p.grantCursedEnergyDomain()

/mob/Admin3/verb/FreeCursedEnergyTraitSlot()
	set category = "Admin"
	var/trait = input(src, "Which Cursed Energy trait slot should be freed?", "Cursed Energy") in CURSED_ENERGY_TRAITS
	if(!trait) return
	cursedEnergyTraitReservations -= trait
	AdminMessage("[src] freed the Cursed Energy trait slot: [trait].")
