/SecretInformation/CursedEnergy
	name = "Cursed Energy"
	maxTier = 5
	givenSkills = list("/obj/Skills/Buffs/SlotlessBuffs/Autonomous/QueueBuff/BlackFlash_Potential")
	var/awakeningConfigured = 0
	var/domainChoicePrompted = 0
	var/CursedEnergyBlackFlashChance = 0
	var/CursedEnergyBlackFlashBaseChance = 5
	var/CursedEnergyBlackFlashFirstTimeUse = 1
	proc/removeBlackFlashSureStrike(mob/p)
		if(!p)
			return
		p.passive_handler.Set("Sure-Strike Black Flash", 0)
		for(var/obj/Skills/Buffs/SlotlessBuffs/BlackFlash_SureStrike/ss in p.Buffs)
			p.DeleteSkill(ss)
	proc/updateSlashCursedTechniques(mob/p)
		if(!p || p.cursedEnergyTrait != "Slash")
			return
		p.passive_handler.Set("BladeFisting", 1)
		var/scale = 1 + (0.5 * max(0, currentTier - 1))
		var/obj/Skills/Projectile/Cursed_Technique_Dismantle/d = locate(/obj/Skills/Projectile/Cursed_Technique_Dismantle) in p
		if(d)
			d.DamageMult = 3 * scale
		var/obj/Skills/AutoHit/Cursed_Technique_Cleave/c = locate(/obj/Skills/AutoHit/Cursed_Technique_Cleave) in p
		if(c)
			c.DamageMult = 4.5 * scale
	proc/grantDomainDefense(mob/p)
		if(!p || domainChoicePrompted)
			return
		domainChoicePrompted = 1
		var/choice = input(p, "Choose an anti-domain technique:", "Domain Defense") in list(
			"Simple Domain - A compact anti-domain barrier that protects the user from sure-hit effects for a short time.",
			"Hollow Wicker Basket - An anti-domain technique that forms a woven barrier to resist enemy Domain sure-hit effects.")
		if(choice)
			if(findtext(choice, "Simple Domain"))
				p.findOrAddSkill(/obj/Skills/Buffs/SlotlessBuffs/Simple_Domain)
				p.cursedEnergyDomainChoice = "Simple Domain"
			else if(findtext(choice, "Hollow Wicker Basket"))
				p.findOrAddSkill(/obj/Skills/Buffs/SlotlessBuffs/Hollow_Wicker_Basket)
				p.cursedEnergyDomainChoice = "Hollow Wicker Basket"
	proc/applyCursedDomainExpansionBuff(obj/Skills/Buffs/SlotlessBuffs/Domain_Expansion/d)
		if(!d)
			return
		d.BuffName = "Domain Expansion Unleashed!"
		d.Mastery = -1
		d.CursedTechnique = 1
		d.UnrestrictedBuff = 1
		d.StrMult = 1.50
		d.ForMult = 1.50
		d.EndMult = 1.50
		d.SpdMult = 1.50
		d.DefMult = 1.50
		d.MakesArmor = 0
		d.TurfShift = 'WhiteTurfShift.dmi'
		d.TurfShiftInstant = 1
		d.OffMult = 1.50
		d.ManaDrain = 2
		d.ManaThreshold = 1
		d.TimerLimit = 200
		d.passives = list("TechniqueMastery" = 5, "BuffMastery" = 2, "MovementMastery" = 5)
		d.DarkChange = 1
	proc/ensureDomainExpansionVerbs(mob/p, obj/Skills/Buffs/SlotlessBuffs/Domain_Expansion/d)
		if(!p || !d)
			return
		if(!(d in p.Skills))
			p.Skills.Add(d)
		if(!(d in p.Buffs))
			p.Buffs.Add(d)
		if(!(d in p.contents))
			p.contents.Add(d)
	proc/grantDomainExpansion(mob/p)
		if(!p)
			return
		var/obj/Skills/Buffs/SlotlessBuffs/Domain_Expansion/d = locate(/obj/Skills/Buffs/SlotlessBuffs/Domain_Expansion) in p
		if(d)
			applyCursedDomainExpansionBuff(d)
			ensureDomainExpansionVerbs(p, d)
			grantDomainDefense(p)
			return
		var/demonName = input(p, "What is the name of your Domain? (e.g. 'Malevolent Shrine' -> activation says 'X says: Domain Expansion.. Malevolent Shrine')", "Domain Expansion - Name") as text|null
		if(!demonName || !length(demonName))
			demonName = "Unnamed Domain"
		var/icon/customTurfIcon = input(p, "Upload the custom floor icon for the Domain (32x32 .dmi, single state).", "Domain Expansion - Turf Icon") as icon|null
		if(!customTurfIcon)
			customTurfIcon = 'WhiteTurfShift.dmi'
		var/finalRange = 15
		var/shroudChoice = input(p, "Should the Domain use a shroud overlay on top of the floor? (Selecting No leaves only the custom floor.)", "Domain Expansion - Shroud") in list("Yes","No")
		var/useShroud = (shroudChoice == "Yes")
		var/icon/customRoofIcon = null
		if(useShroud)
			customRoofIcon = input(p, "Upload the custom shroud icon for the Domain (32x32 .dmi, single state). Cancel to fall back to the default Roofs.dmi shroud.", "Domain Expansion - Shroud Icon") as icon|null
		d = new/obj/Skills/Buffs/SlotlessBuffs/Domain_Expansion/Cursed_Energy()
		d.demonName = copytext("[demonName]", 1, 65)
		d.customTurfIcon = customTurfIcon
		d.customRoofIcon = customRoofIcon
		d.useShroud = useShroud
		d.range = finalRange
		d.ActiveMessage = "says: Domain Expansion.. [d.demonName]!"
		d.OffMessage = "conceals the domain of [d.demonName]..."
		applyCursedDomainExpansionBuff(d)
		p.AddSkill(d)
		ensureDomainExpansionVerbs(p, d)
		p << "You have gained Domain Expansion ([d.demonName], range [finalRange], shroud [useShroud ? "on" : "off"])."
		grantDomainDefense(p)
	proc/getDomainSureHitSkill(trait)
		switch(trait)
			if("Serrated")
				return /obj/Skills/Buffs/SlotlessBuffs/Cursed_Domain_Gamblers_Luck
			if("Slash")
				return /obj/Skills/AutoHit/Cursed_Domain_Dismantle
			if("Electricity")
				return /obj/Skills/AutoHit/Cursed_Domain_Electric_Discharge
			if("Spatial Manipulation")
				return /obj/Skills/AutoHit/Cursed_Domain_Infinite_Void

		return null
	proc/grantDomainSureHit(mob/p)
		if(!p || !p.hasSecret("Cursed Energy"))
			return
		var/skillPath = getDomainSureHitSkill(p.cursedEnergyTrait)
		if(skillPath)
			p.findOrAddSkill(skillPath)
	proc/getTraitPassives(trait)
		switch(trait)
			if("Electricity")
				return list("Shocking" = 2, "ThunderHerald" = 1, "CriticalChance" = 10)
			if("Slash")
				return list("Shearing" = 2, "Crippling" = 1, "CriticalChance" = 15)
			if("Serrated")
				return list("Shearing" = 2, "Shattering" = 2, "CriticalChance" = 10)
			if("Spatial Manipulation")
				return list("Flow" = 2, "Instinct" = 2, "Deflection" = 1)
			if("Immolation")
				return list("Scorching" = 4, "Burning" = 2, "PureDamage" = 0.5)

		return list()
	proc/getActiveTraitPassives(mob/p)
		if(!p || !p.hasSecret("Cursed Energy"))
			return list()

		return getTraitPassives(p.cursedEnergyTrait)
	proc/getSpecializationPassives(specialization)
		switch(specialization)
			if("Cursed Energy Reinforcement")
				return list("Cursed Energy Reinforcement" = 1, "UnarmedDamage" = 3, "CriticalDamage" = 2, "CriticalChance" = 2, "CriticalBlock" = 2, "PureReduction" = 2, "Flow" = 4, "Adrenaline" = 3, "Fury" = 2)
			if("Cursed Energy Enrichment")
				return list("Cursed Energy Enrichment" = 1, "Adrenaline" = 3, "MeleeResist" = 2, "ManaSteal" = 20, "ManaGeneration" = 3, "PowerfulCasting" = 2, "StalwartCasting" = 2, "FluidForm" = 3, "Fury" = 2)
			if("Cursed Energy Enhancement")
				return list("Cursed Energy Enhancement" = 1, "Fury" = 2, "Parry" = 2, "Reversal" = 2, "Instinct" = 4, "SwordDamage" = 2, "Adrenaline" = 3, "SwordAscension" = 1)

		return list()

	proc/addSpecializationPassivesToKiControl(mob/p, obj/Skills/Buffs/ActiveBuffs/Ki_Control/ki)
		if(!p || !ki)
			return
		if(ki.cursedEnergySpecializationPassivesApplied)
			for(var/oldPassive in ki.cursedEnergySpecializationPassivesApplied)
				ki.passives[oldPassive] -= ki.cursedEnergySpecializationPassivesApplied[oldPassive]
			ki.cursedEnergySpecializationPassivesApplied = null
		if(currentTier < 2 || !p.cursedEnergySpecialization)
			return
		var/list/specializationPassives = getSpecializationPassives(p.cursedEnergySpecialization)
		for(var/passive in specializationPassives)
			ki.passives[passive] += specializationPassives[passive]
		ki.cursedEnergySpecializationPassivesApplied = specializationPassives.Copy()

	proc/removePermanentSpecializationPassives(mob/p)
		if(!p || !p.passive_handler || !p.cursedEnergySpecialization || p.cursedEnergySpecializationPassiveMigrated)
			return
		var/list/specializationPassives = getSpecializationPassives(p.cursedEnergySpecialization)
		if(specializationPassives.len)
			p.passive_handler.decreaseList(specializationPassives)
		p.cursedEnergySpecializationPassiveMigrated = 1

	proc/chooseSpecialization(mob/p)
		if(!p)
			return
		if(p.cursedEnergySpecialization)
			return
		var/list/options = list("Cursed Energy Reinforcement", "Cursed Energy Enrichment", "Cursed Energy Enhancement")
		var/choice = input(p, "Choose your Cursed Energy specialization.", "Cursed Energy - Specialization") in options
		if(!choice)
			choice = "Cursed Energy Reinforcement"
		p.cursedEnergySpecialization = choice
		p.cursedEnergySpecializationPassiveMigrated = 1
		switch(choice)
			if("Cursed Energy Reinforcement")
				p << "You focus on Cursed Energy Reinforcement, hardening body and impact. Its benefits flow through Ki Control."
			if("Cursed Energy Enrichment")
				p << "You focus on Cursed Energy Enrichment, improving flow and technique conversion. Its benefits flow through Ki Control."
			if("Cursed Energy Enhancement")
				p << "You focus on Cursed Energy Enhancement, sharpening weapon flow and reactions. Its benefits flow through Ki Control."
		p.refreshCursedEnergyKiControlSpecialization()
	applySecret(mob/p)
		if(!p)
			return
		removeBlackFlashSureStrike(p)
		removePermanentSpecializationPassives(p)
		p.refreshCursedEnergyKiControlSpecialization()
		p.passive_handler.Set("RenameMana", "Cursed Energy")
		p.setupCursedEnergyAwakening()
		p.applyCursedEnergyPowerControlIcon()
		grantDomainSureHit(p)
		p.refreshCursedEnergyTraitPassives()
		switch(currentTier)
			if(1)
				p << "You awaken to the flow of Cursed Energy."
				giveSkills(p)
				CursedEnergyBlackFlashBaseChance = 5
				if(prob(10))
					grantDomainExpansion(p)
				nextTierUp = 2
			if(2)
				p << "Your Cursed Energy control improves."
				CursedEnergyBlackFlashBaseChance = 25
				p.passive_handler.Set("Sparks of Black", 1)
				chooseSpecialization(p)
				if(prob(20))
					grantDomainExpansion(p)
				nextTierUp = 3
			if(3)
				p << "Your Cursed Energy grows denser and more precise."
				CursedEnergyBlackFlashBaseChance = 35
				if(prob(35))
					grantDomainExpansion(p)
				nextTierUp = 4
			if(4)
				p << "Your Cursed Energy reaches a breakthrough: Domain Expansion is now yours by default."
				CursedEnergyBlackFlashBaseChance = 35
				grantDomainExpansion(p)
				nextTierUp = 5
			if(5)
				p << "Your Domain mastery deepens."
				CursedEnergyBlackFlashBaseChance = 35
				grantDomainExpansion(p)
				nextTierUp = 999
		CursedEnergyBlackFlashBaseChance = min(CursedEnergyBlackFlashBaseChance, 35)
		CursedEnergyBlackFlashChance = clamp(CursedEnergyBlackFlashChance, CursedEnergyBlackFlashBaseChance, 35)

		updateSlashCursedTechniques(p)
		if(p.cursedEnergyTrait == "Spatial Manipulation")
			p.updateCursedEnergySpatialTechniques()
		if(p.cursedEnergyTrait == "Immolation")
			p.updateCursedEnergyImmolationTechniques()


mob/proc/applyCursedEnergyPowerControlIcon()
	if(!hasSecret("Cursed Energy"))
		return
	for(var/obj/Skills/Power_Control/pc in src)
		pc.sicon = 'Aura_CursedEnergyLeak.dmi'
		pc.sicon_state = null
		pc.pixel_x = 0
		pc.pixel_y = 0


mob/proc/resetCursedEnergyPowerControlIcon()
	for(var/obj/Skills/Power_Control/pc in src)
		if(pc.sicon == 'Aura_CursedEnergyLeak.dmi')
			pc.sicon = initial(pc.sicon)
			pc.sicon_state = initial(pc.sicon_state)
			pc.pixel_x = initial(pc.pixel_x)
			pc.pixel_y = initial(pc.pixel_y)


mob/proc/applyCursedEnergyKiControlDefaults()
	for(var/obj/Skills/Buffs/ActiveBuffs/Ki_Control/ki in src)
		ki.init(src)
		ki.applyCursedEnergyDefaults(src)


mob/proc/refreshCursedEnergyKiControlSpecialization()
	for(var/obj/Skills/Buffs/ActiveBuffs/Ki_Control/ki in src)
		var/wasActive = (src.ActiveBuff == ki)
		if(wasActive && ki.current_passives && ki.current_passives.len)
			passive_handler.decreaseList(ki.current_passives)
		ki.init(src)
		ki.applyCursedEnergyDefaults(src)
		if(wasActive)
			ki.current_passives = ki.passives
			passive_handler.increaseList(ki.current_passives)


mob
	var
		cursedEnergyAuraColor
		cursedEnergyTrait
		cursedEnergySpecialization
		cursedEnergySpecializationPassiveMigrated
		cursedEnergyDomainChoice
		cursedEnergyTraitSlot
		cursedEnergyPoseHealReady
		cursedEnergyPoseHealCooldown
		cursedEnergySixEyes
		image/cursedEnergySixEyesOverlay
		list/cursedEnergyInfiniteVoidEscapes
		list/cursedEnergyTraitPassivesApplied


proc/logCursedEnergyTraitSlots(var/message)
	if(!cursed_energy_taken_traits)
		cursed_energy_taken_traits = list()
	var/list/occupied = list()
	for(var/trait in cursed_energy_taken_traits)
		occupied += "[trait]=[cursed_energy_taken_traits[trait]]"
	var/slotText = occupied.len ? jointext(occupied, ", ") : "none"
	AdminMessage("Cursed Energy trait slots: [message]. Occupied: [slotText]", 1)


mob/Admin3/verb/Manage_Cursed_Energy_Slots()
	set category = "Admin"
	if(!cursed_energy_taken_traits || !cursed_energy_taken_traits.len)
		usr << "No Cursed Energy trait slots are currently occupied."
		return
	var/list/choices = list()
	for(var/trait in cursed_energy_taken_traits)
		var/owner = cursed_energy_taken_traits[trait]
		var/ownerText = owner ? owner : "stale/empty"
		choices["[trait] - [ownerText]"] = trait
	if(!choices.len)
		usr << "No Cursed Energy trait slots are currently occupied."
		return
	var/choice = input(usr, "Select a Cursed Energy trait slot to free.", "Cursed Energy Slot Manager") as null|anything in choices
	if(!choice)
		return
	var/trait = choices[choice]
	var/owner = cursed_energy_taken_traits[trait]
	var/slotOwnerText = owner ? owner : "stale/empty"
	var/confirm = alert(usr, "Free [trait]'s Cursed Energy slot currently held by [slotOwnerText]? This does not remove Cursed Energy from any character.", "Confirm Slot Removal", "Yes", "No")
	if(confirm != "Yes")
		return
	if(!cursed_energy_taken_traits || !(trait in cursed_energy_taken_traits))
		usr << "That Cursed Energy slot is already free."
		return
	cursed_energy_taken_traits -= trait
	usr << "Freed the [trait] Cursed Energy slot."
	Log("Admin", "[ExtractInfo(usr)] freed the [trait] Cursed Energy slot formerly held by [slotOwnerText].")
	logCursedEnergyTraitSlots("[usr] manually freed [trait]")


mob/proc/cursedEnergySlotOwnerId()
	if(src.ckey)
		return src.ckey
	if(src.key)
		return ckey(src.key)
	return "[src]"


mob/proc/reserveCursedEnergyTrait(var/trait)
	if(!cursed_energy_taken_traits)
		cursed_energy_taken_traits = list()
	if(!trait)
		return 0
	var/owner = cursedEnergySlotOwnerId()
	var/currentOwner = cursed_energy_taken_traits[trait]
	if(currentOwner && currentOwner != owner)
		return 0
	cursed_energy_taken_traits[trait] = owner
	cursedEnergyTraitSlot = trait
	logCursedEnergyTraitSlots("[src] reserved [trait]")
	return 1


mob/proc/freeCursedEnergyTrait(var/force = 0)
	if(!cursed_energy_taken_traits)
		cursed_energy_taken_traits = list()
	var/owner = cursedEnergySlotOwnerId()
	var/trait = cursedEnergyTraitSlot
	if(!trait)
		trait = cursedEnergyTrait
	if(!trait)
		return
	if(cursed_energy_taken_traits[trait] == owner || force)
		cursed_energy_taken_traits -= trait
		logCursedEnergyTraitSlots("[src] freed [trait]")
	cursedEnergyTraitSlot = null


mob/proc/getAvailableCursedEnergyTraits()
	if(!cursed_energy_taken_traits)
		cursed_energy_taken_traits = list()
	var/list/traits = list("Serrated", "Electricity", "Slash", "Spatial Manipulation", "Immolation")
	var/list/available = list()
	var/owner = cursedEnergySlotOwnerId()
	for(var/trait in traits)
		if(!cursed_energy_taken_traits[trait] || cursed_energy_taken_traits[trait] == owner)
			available += trait
	return available


mob/proc/ensureCursedEnergyStillValid()
	if(Secret == "Cursed Energy" && istype(secretDatum, /SecretInformation/CursedEnergy))
		return
	if(cursedEnergyTrait || cursedEnergyTraitSlot || cursedEnergyTraitPassivesApplied)
		cleanupCursedEnergy()


mob/proc/getCursedEnergySecret()
	if(hasSecret("Cursed Energy") && istype(secretDatum, /SecretInformation/CursedEnergy))
		return secretDatum

	return null




mob/proc/getCursedEnergyDrain(var/drain, obj/Skills/S)
	if(!isnum(drain) || drain <= 0)
		return drain
	if(!S || !S.CursedTechnique)
		return drain
	var/SecretInformation/CursedEnergy/ce = getCursedEnergySecret()
	if(!ce)
		return drain
	var/tier = max(1, ce.currentTier)
	var/reduction = min(0.4, max(0, tier - 1) * 0.1)
	if(src.HasSixEyes())
		reduction = min(0.75, reduction + 0.35)
	if(reduction <= 0)
		return drain
	var/adjustedDrain = drain * (1 - reduction)
	if(adjustedDrain <= 0)
		return drain
	return adjustedDrain

mob/proc/canUseCursedEnergyDomainSureHit(requiredTrait)
	if(!getCursedEnergySecret() || cursedEnergyTrait != requiredTrait)
		src << "You cannot use this sure-hit technique."
		return 0

	var/obj/Skills/Buffs/SlotlessBuffs/Domain_Expansion/d = locate(/obj/Skills/Buffs/SlotlessBuffs/Domain_Expansion) in src
	if(!d || !domainExpansionActive || !BuffOn(d))
		src << "This sure-hit technique can only be used while your Domain Expansion is active."
		return 0

	return 1


mob/proc/collapseCursedEnergyDomainSureHit()
	var/obj/Skills/Buffs/SlotlessBuffs/Domain_Expansion/d = locate(/obj/Skills/Buffs/SlotlessBuffs/Domain_Expansion) in src
	if(d && BuffOn(d))
		d.releaseDomain(src, src)
	else
		stopDomainExapansion()


mob/proc/finishCursedEnergyDomainSureHit(obj/Skills/sureHit)
	if(!sureHit)
		return
	var/delay = 1
	if(istype(sureHit, /obj/Skills/AutoHit))
		var/obj/Skills/AutoHit/a = sureHit
		delay = max(1, a.Rounds * max(1, a.DelayTime))
	spawn(delay)
		if(src && src.domainExpansionActive)
			var/obj/Skills/Buffs/SlotlessBuffs/Domain_Expansion/d = locate(/obj/Skills/Buffs/SlotlessBuffs/Domain_Expansion) in src
			src.collapseCursedEnergyDomainSureHit()
			if(d && !d.Using && !d.cooldown_remaining)
				d.Cooldown(p = src)


mob/proc/isCursedEnergyBlackFlashFirstUse()
	var/SecretInformation/CursedEnergy/ce = getCursedEnergySecret()

	if(ce)
		return ce.CursedEnergyBlackFlashFirstTimeUse

	return 0


mob/proc/setCursedEnergyBlackFlashFirstUse()
	var/SecretInformation/CursedEnergy/ce = getCursedEnergySecret()

	if(ce)
		ce.CursedEnergyBlackFlashFirstTimeUse = 0


mob/proc/safeRemoveCursedEnergyPassives(list/passivesToRemove)
	if(!passive_handler || !passivesToRemove || !passivesToRemove.len)
		return
	for(var/passive in passivesToRemove)
		var/value = passivesToRemove[passive]
		if(!isnum(value))
			continue
		var/current = passive_handler.Get(passive)
		if(!isnum(current) || current <= 0)
			continue
		if(current <= value)
			passive_handler.Set(passive, 0)
		else
			passive_handler.Decrease(passive, value)


mob/proc/removeCursedEnergyTraitPassives()
	if(cursedEnergyTraitPassivesApplied && cursedEnergyTraitPassivesApplied.len)
		safeRemoveCursedEnergyPassives(cursedEnergyTraitPassivesApplied)
	cursedEnergyTraitPassivesApplied = null


mob/proc/refreshCursedEnergyTraitPassives()
	removeCursedEnergyTraitPassives()
	var/SecretInformation/CursedEnergy/ce = getCursedEnergySecret()
	if(!ce)
		return
	ce.grantDomainSureHit(src)
	var/list/traitPassives = ce.getActiveTraitPassives(src)
	if(!traitPassives.len)
		return
	passive_handler.increaseList(traitPassives)
	cursedEnergyTraitPassivesApplied = traitPassives.Copy()


mob/proc/setupCursedEnergyAwakening()
	var/SecretInformation/CursedEnergy/ce = getCursedEnergySecret()

	if(!ce)
		return
	if(ce.awakeningConfigured)
		applyCursedEnergyPowerControlIcon()
		updateCursedEnergySixEyesOverlay()
		if(cursedEnergyTrait && !cursedEnergyTraitSlot)
			if(!reserveCursedEnergyTrait(cursedEnergyTrait))
				src << "Your Cursed Energy trait slot is already occupied; Cursed Energy has been cleaned up."
				cleanupCursedEnergy()
				return
		ce.grantDomainSureHit(src)
		refreshCursedEnergyTraitPassives()
		return

	var/chosenColor = input(src, "Choose aura color.", "Cursed Energy") as color|null
	if(chosenColor)
		cursedEnergyAuraColor = chosenColor

	var/list/traits = getAvailableCursedEnergyTraits()
	if(!traits.len)
		src << "No unique Cursed Energy trait slots are currently available."
		logCursedEnergyTraitSlots("[src] could not reserve a trait")
		return
	var/selected = pick(traits)
	if(!reserveCursedEnergyTrait(selected))
		src << "That Cursed Energy trait slot is already occupied."
		logCursedEnergyTraitSlots("[src] failed to reserve [selected]")
		return

	cursedEnergyTrait = selected
	cursedEnergyPoseHealReady = 1

	switch(selected)
		if("Serrated")
			findOrAddSkill(/obj/Skills/Queue/Cursed_Technique_Gamblers_Fist)
			findOrAddSkill(/obj/Skills/AutoHit/Shutter_Doors)
			src << "Your cursed energy becomes serrated."

		if("Electricity")
			findOrAddSkill(/obj/Skills/AutoHit/Cursed_Voltage_Strike)
			src << "Your cursed energy crackles with electricity."

		if("Slash")
			findOrAddSkill(/obj/Skills/Projectile/Cursed_Technique_Dismantle)
			findOrAddSkill(/obj/Skills/AutoHit/Cursed_Technique_Cleave)
			ce.updateSlashCursedTechniques(src)
			src << "Your cursed energy gains slicing properties."

		if("Spatial Manipulation")
			findOrAddSkill(/obj/Skills/Buffs/SlotlessBuffs/Limitless)
			findOrAddSkill(/obj/Skills/AutoHit/Cursed_Technique_Red)
			findOrAddSkill(/obj/Skills/AutoHit/Cursed_Technique_Blue)
			findOrAddSkill(/obj/Skills/Projectile/Cursed_Technique_Hollow_Purple)
			updateCursedEnergySpatialTechniques()
			if(prob(10))
				cursedEnergySixEyes = 1
				src << "The Six Eyes awaken behind your Limitless cursed technique."
			src << "Your cursed energy begins folding space through Limitless."

		if("Immolation")
			findOrAddSkill(/obj/Skills/Buffs/SlotlessBuffs/Disaster_Flames)
			findOrAddSkill(/obj/Skills/AutoHit/Cursed_Technique_Volcanic_Strike)
			findOrAddSkill(/obj/Skills/Projectile/Cursed_Technique_Maximum_Meteor)
			updateCursedEnergyImmolationTechniques()
			src << "Your cursed energy erupts into Disaster Flames."

	ce.awakeningConfigured = 1
	applyCursedEnergyPowerControlIcon()
	updateCursedEnergySixEyesOverlay()
	refreshCursedEnergyTraitPassives()


mob/proc/attemptCursedHeavyStrike()
	if(!getCursedEnergySecret())
		return 0

	if(cursedEnergyTrait == "Electricity")
		var/obj/Skills/AutoHit/Cursed_Voltage_Strike/cvs = findOrAddSkill(/obj/Skills/AutoHit/Cursed_Voltage_Strike)
		if(cvs && !cvs.Using && !cvs.cooldown_remaining)
			cvs.adjust(src)
			throwSkill(cvs)
			return 1

	if(cursedEnergyTrait == "Slash")
		var/obj/Skills/AutoHit/Cursed_Technique_Cleave/c = findOrAddSkill(/obj/Skills/AutoHit/Cursed_Technique_Cleave)
		if(c && !c.Using && !c.cooldown_remaining)
			c.adjust(src)
			throwSkill(c)
			return 1

	if(cursedEnergyTrait == "Serrated")
		var/obj/Skills/Queue/Cursed_Technique_Gamblers_Fist/gf = findOrAddSkill(/obj/Skills/Queue/Cursed_Technique_Gamblers_Fist)
		if(gf && !gf.Using && !gf.cooldown_remaining)
			SetQueue(gf)
			return 1

	if(cursedEnergyTrait == "Spatial Manipulation")
		if(Target && Target != src && get_dist(src, Target) <= 25 && Target.z == z)
			var/obj/Skills/AutoHit/spatial
			if(get_dist(src, Target) <= 2)
				spatial = findOrAddSkill(/obj/Skills/AutoHit/Cursed_Technique_Red)
			else
				spatial = findOrAddSkill(/obj/Skills/AutoHit/Cursed_Technique_Blue)
			if(spatial && !spatial.Using && !spatial.cooldown_remaining)
				call(spatial, "adjust")(src)
				throwSkill(spatial)
				var/obj/Skills/AutoHit/otherSpatial = null
				if(istype(spatial, /obj/Skills/AutoHit/Cursed_Technique_Red))
					otherSpatial = locate(/obj/Skills/AutoHit/Cursed_Technique_Blue) in src
				else
					otherSpatial = locate(/obj/Skills/AutoHit/Cursed_Technique_Red) in src
				if(otherSpatial && !otherSpatial.cooldown_remaining)
					otherSpatial.Cooldown(modify = 1, Time = 600, p = src, announce_cd = 0)
				triggerSixEyesCooldownReduction(spatial)
				return 1

	if(cursedEnergyTrait == "Immolation")
		var/obj/Skills/AutoHit/Cursed_Technique_Volcanic_Strike/vs = findOrAddSkill(/obj/Skills/AutoHit/Cursed_Technique_Volcanic_Strike)
		if(vs && !vs.Using && !vs.cooldown_remaining)
			vs.adjust(src)
			throwSkill(vs)
			return 1

	if(!canBlackFlashStrike())
		return 1

	var/obj/Skills/Queue/Secret_Heavy_Strike/hs = getBlackFlashStrike()
	if(hs)
		hs.adjust(src)
		SetQueue(hs)

	return 1


mob/proc/attemptCursedToss()
	if(!getCursedEnergySecret())
		return 0

	if(cursedEnergyTrait == "Serrated")
		var/obj/Skills/AutoHit/Shutter_Doors/sd = locate(/obj/Skills/AutoHit/Shutter_Doors) in src
		if(sd && !sd.Using && !sd.cooldown_remaining)
			return sd.Trigger(src)

	if(cursedEnergyTrait == "Slash")
		var/obj/Skills/Projectile/Cursed_Technique_Dismantle/d = findOrAddSkill(/obj/Skills/Projectile/Cursed_Technique_Dismantle)
		if(d && !d.Using && !d.cooldown_remaining)
			return d.Trigger(src)

	if(cursedEnergyTrait == "Spatial Manipulation")
		var/obj/Skills/Projectile/Cursed_Technique_Hollow_Purple/hp = findOrAddSkill(/obj/Skills/Projectile/Cursed_Technique_Hollow_Purple)
		if(hp && !hp.Using && !hp.cooldown_remaining)
			hp.adjust(src)
			var/usedPurple = hp.Trigger(src)
			if(usedPurple)
				triggerSixEyesCooldownReduction(hp)
			return usedPurple
		return 0

	if(cursedEnergyTrait == "Immolation")
		var/obj/Skills/Projectile/Cursed_Technique_Maximum_Meteor/mm = findOrAddSkill(/obj/Skills/Projectile/Cursed_Technique_Maximum_Meteor)
		if(mm && !mm.Using && !mm.cooldown_remaining)
			mm.adjust(src)
			return mm.Trigger(src)
		return 0

	return 0


mob/proc/attemptCursedReverseDash()
	if(!getCursedEnergySecret())
		return 0

	if(!cursedEnergyDomainChoice)
		return 0

	if(cursedEnergyDomainChoice == "Simple Domain")
		var/obj/Skills/Buffs/SlotlessBuffs/Simple_Domain/sd = locate(/obj/Skills/Buffs/SlotlessBuffs/Simple_Domain) in src
		if(sd && !sd.Using && !sd.cooldown_remaining && sd.Trigger(src))
			return 1

	if(cursedEnergyDomainChoice == "Hollow Wicker Basket")
		var/obj/Skills/Buffs/SlotlessBuffs/Hollow_Wicker_Basket/hwb = locate(/obj/Skills/Buffs/SlotlessBuffs/Hollow_Wicker_Basket) in src
		if(hwb && !hwb.Using && !hwb.cooldown_remaining && hwb.Trigger(src))
			return 1

	return 0


mob/proc/activateReversedCursedTechnique()
	var/SecretInformation/CursedEnergy/ce = getCursedEnergySecret()

	if(!ce || !cursedEnergyPoseHealReady || world.time < cursedEnergyPoseHealCooldown)
		return

	var/healPercent = 0

	switch(ce.currentTier)
		if(1)
			healPercent = 0.08
		if(2)
			healPercent = 0.095
		if(3)
			healPercent = 0.11
		if(4)
			healPercent = 0.125
		if(5)
			healPercent = 0.14
		else
			healPercent = 0.08

	if(TotalInjury > 0)
		HealWounds(TotalInjury, 1)

	if(Maimed)
		Maimed = 0
	if(MortallyWounded)
		MortallyWounded = 0
	HealthCut = 0
	MaxHealth()

	var/list/clearedDebuffs = ClearDebuffs()
	if(clearedDebuffs && clearedDebuffs.len)
		src << "Reversed Curse Technique purges your active debuffs: [jointext(clearedDebuffs, ", ")]."
	else
		src << "Reversed Curse Technique finds no active debuffs to purge."

	if(HasSixEyes())
		healPercent *= 2
	var/healAmount = round(100 * healPercent, 0.1)
	if(healAmount > 0)
		HealHealth(healAmount)

	ManaAmount += 50
	MaxMana()

	cursedEnergyPoseHealReady = 0
	cursedEnergyPoseHealCooldown = world.time + 300
	spawn(300)
		if(src && src.hasSecret("Cursed Energy") && world.time >= cursedEnergyPoseHealCooldown)
			cursedEnergyPoseHealReady = 1
			src << "Reversed Curse Technique is available again."

	world << "[src.name] utilizes Reversed Curse Technique and restores their body instantly!"



mob/proc/updateCursedEnergySpatialTechniques()
	var/SecretInformation/CursedEnergy/ce = getCursedEnergySecret()
	if(!ce)
		return
	var/tier = max(1, ce.currentTier)
	var/scale = 1 + (0.25 * (tier - 1))
	var/obj/Skills/AutoHit/Cursed_Technique_Red/red = locate(/obj/Skills/AutoHit/Cursed_Technique_Red) in src
	if(red)
		red.DamageMult = 11 * scale
		red.ManaCost = 12 + (tier * 2)
	var/obj/Skills/AutoHit/Cursed_Technique_Blue/blue = locate(/obj/Skills/AutoHit/Cursed_Technique_Blue) in src
	if(blue)
		blue.DamageMult = 7 * scale
		blue.ManaCost = 10 + (tier * 2)
	var/obj/Skills/Projectile/Cursed_Technique_Hollow_Purple/purple = locate(/obj/Skills/Projectile/Cursed_Technique_Hollow_Purple) in src
	if(purple)
		purple.DamageMult = 6 * scale
		purple.ManaCost = 25 + (tier * 3)


mob/proc/updateCursedEnergyImmolationTechniques()
	var/SecretInformation/CursedEnergy/ce = getCursedEnergySecret()
	if(!ce)
		return
	var/tier = max(1, ce.currentTier)
	var/scale = 1 + (0.2 * (tier - 1))
	var/obj/Skills/AutoHit/Cursed_Technique_Volcanic_Strike/strike = locate(/obj/Skills/AutoHit/Cursed_Technique_Volcanic_Strike) in src
	if(strike)
		strike.DamageMult = 6 * scale
		strike.ManaCost = 10 + (tier * 2)
		strike.Scorching = 20 + (tier * 8)
	var/obj/Skills/Projectile/Cursed_Technique_Maximum_Meteor/meteor = locate(/obj/Skills/Projectile/Cursed_Technique_Maximum_Meteor) in src
	if(meteor)
		meteor.DamageMult = 8 * scale
		meteor.ManaCost = 22 + (tier * 4)
		meteor.Scorching = 40 + (tier * 12)


mob/proc/HasSixEyes()
	return getCursedEnergySecret() && cursedEnergySixEyes && cursedEnergyTrait == "Spatial Manipulation"


mob/proc/removeCursedEnergySixEyesOverlay()
	if(cursedEnergySixEyesOverlay)
		overlays -= cursedEnergySixEyesOverlay
	// Clean up legacy Six Eyes visuals that used to be tied to the Limitless buff.
	overlays -= image(icon = 'BlueSixEyes.dmi', layer = FLOAT_LAYER-1)
	overlays -= image(icon = 'cosmiceyes.dmi', pixel_x = 0, pixel_y = 0, layer = FLOAT_LAYER-1)
	overlays -= image(icon = 'Eyes.dmi', icon_state = "Blindfold", pixel_x = 0, pixel_y = 0, layer = FLOAT_LAYER-1)
	cursedEnergySixEyesOverlay = null


mob/proc/applyCursedEnergySixEyesOverlay()
	removeCursedEnergySixEyesOverlay()
	if(!HasSixEyes())
		return
	cursedEnergySixEyesOverlay = image(icon = 'BlueSixEyes.dmi', layer = FLOAT_LAYER-1)
	overlays += cursedEnergySixEyesOverlay


mob/proc/updateCursedEnergySixEyesOverlay()
	if(HasSixEyes())
		applyCursedEnergySixEyesOverlay()
	else
		removeCursedEnergySixEyesOverlay()


mob/proc/triggerSixEyesCooldownReduction(obj/Skills/exclude, var/includeDomain = 0)
	if(!HasSixEyes())
		return
	for(var/obj/Skills/s in Skills)
		if(!s || s == exclude)
			continue
		if(!includeDomain && istype(s, /obj/Skills/Buffs/SlotlessBuffs/Domain_Expansion))
			continue
		if(s.cooldown_remaining > 0)
			var/newTime = max(0, s.cooldown_remaining - 300)
			if(newTime <= 0)
				s.cooldown_remaining = 0
				s.Using = 0
				s.cooldown_start = 0
			else
				s.Cooldown(modify = 1, Time = newTime, p = src, announce_cd = 0)


mob/proc/tickInfiniteVoidDomain(obj/Skills/Buffs/SlotlessBuffs/Domain_Expansion/domain)
	if(!domain || cursedEnergyTrait != "Spatial Manipulation" || !domainExpansionActive || !BuffOn(domain))
		return
	if(!cursedEnergyInfiniteVoidEscapes)
		cursedEnergyInfiniteVoidEscapes = list()
	var/list/current = list()
	for(var/mob/m in oview(domain.range, src))
		if(!m || m == src)
			continue
		if(party && (m in party.members))
			continue
		if(!m.client && !isAI(m))
			continue
		current += m
		var/progress = cursedEnergyInfiniteVoidEscapes[m]
		if(!isnum(progress))
			progress = 0
		progress += rand(8, 18)
		cursedEnergyInfiniteVoidEscapes[m] = progress
		if(progress >= 100)
			continue
		Stun(m, 1.5, TRUE)
		m.Frozen = max(m.Frozen, 1)
		spawn(12)
			if(m && m.Frozen == 1)
				m.Frozen = 0
	for(var/mob/old in cursedEnergyInfiniteVoidEscapes)
		if(!(old in current))
			cursedEnergyInfiniteVoidEscapes -= old

mob/proc/removeCursedEnergySkill(var/path)
	var/obj/Skills/s = locate(path) in src
	while(s)
		DeleteSkill(s)
		s = locate(path) in src


mob/proc/cleanupCursedEnergy()
	removeCursedEnergyTraitPassives()
	resetCursedEnergyPowerControlIcon()
	if(passive_handler)
		passive_handler.Set("RenameMana", 0)
		passive_handler.Set("Sparks of Black", 0)
		if(cursedEnergyTrait == "Slash")
			passive_handler.Set("BladeFisting", 0)
		passive_handler.Set("Sure-Strike Black Flash", 0)
	var/list/specializationPassives = list()
	if(istype(secretDatum, /SecretInformation/CursedEnergy) && cursedEnergySpecialization)
		var/SecretInformation/CursedEnergy/ce = secretDatum
		specializationPassives = ce.getSpecializationPassives(cursedEnergySpecialization)
		if(specializationPassives.len && !cursedEnergySpecializationPassiveMigrated)
			safeRemoveCursedEnergyPassives(specializationPassives)
	for(var/obj/Skills/Buffs/ActiveBuffs/Ki_Control/ki in src)
		if(ki.cursedEnergySpecializationPassivesApplied)
			if(src.ActiveBuff == ki)
				safeRemoveCursedEnergyPassives(ki.cursedEnergySpecializationPassivesApplied)
			for(var/oldPassive in ki.cursedEnergySpecializationPassivesApplied)
				var/value = ki.cursedEnergySpecializationPassivesApplied[oldPassive]
				if(!isnum(value))
					continue
				if(!isnum(ki.passives[oldPassive]) || ki.passives[oldPassive] <= value)
					ki.passives[oldPassive] = 0
				else
					ki.passives[oldPassive] -= value
			ki.cursedEnergySpecializationPassivesApplied = null
	if(domainExpansionActive)
		stopDomainExapansion()
	var/list/cursedSkills = list(
		/obj/Skills/Buffs/SlotlessBuffs/Autonomous/QueueBuff/BlackFlash_Potential,
		/obj/Skills/Buffs/SlotlessBuffs/BlackFlash_SureStrike,
		/obj/Skills/Buffs/SlotlessBuffs/Domain_Expansion,
		/obj/Skills/Buffs/SlotlessBuffs/Domain_Expansion/Cursed_Energy,
		/obj/Skills/Buffs/SlotlessBuffs/Simple_Domain,
		/obj/Skills/Buffs/SlotlessBuffs/Hollow_Wicker_Basket,
		/obj/Skills/Buffs/SlotlessBuffs/Cursed_Domain_Gamblers_Luck,
		/obj/Skills/Projectile/Cursed_Domain_Dismantle,
		/obj/Skills/AutoHit/Cursed_Domain_Dismantle,
		/obj/Skills/AutoHit/Cursed_Domain_Electric_Discharge,
		/obj/Skills/Queue/Cursed_Technique_Gamblers_Fist,
		/obj/Skills/Queue/Cursed_Technique_Dismantle,
		/obj/Skills/Projectile/Cursed_Technique_Dismantle,
		/obj/Skills/AutoHit/Cursed_Technique_Cleave,
		/obj/Skills/AutoHit/Cursed_Voltage_Strike,
		/obj/Skills/AutoHit/Shutter_Doors,
		/obj/Skills/Buffs/SlotlessBuffs/Limitless,
		/obj/Skills/Buffs/SlotlessBuffs/Disaster_Flames,
		/obj/Skills/AutoHit/Cursed_Technique_Red,
		/obj/Skills/AutoHit/Cursed_Technique_Blue,
		/obj/Skills/AutoHit/Cursed_Technique_Volcanic_Strike,
		/obj/Skills/AutoHit/Cursed_Domain_Infinite_Void,
		/obj/Skills/Projectile/Cursed_Technique_Hollow_Purple,
		/obj/Skills/Projectile/Cursed_Technique_Maximum_Meteor)
	for(var/path in cursedSkills)
		removeCursedEnergySkill(path)
	freeCursedEnergyTrait()
	cursedEnergyAuraColor = null
	cursedEnergyTrait = null
	cursedEnergySpecialization = null
	cursedEnergySpecializationPassiveMigrated = null
	cursedEnergyDomainChoice = null
	cursedEnergyPoseHealReady = 0
	cursedEnergyPoseHealCooldown = 0
	removeCursedEnergySixEyesOverlay()
	cursedEnergySixEyes = 0
	cursedEnergyInfiniteVoidEscapes = null
	if(Secret == "Cursed Energy")
		Secret = null
	if(istype(secretDatum, /SecretInformation/CursedEnergy))
		secretDatum = new/SecretInformation
	AdminMessage("[src] cleaned up Cursed Energy state.", 1)
