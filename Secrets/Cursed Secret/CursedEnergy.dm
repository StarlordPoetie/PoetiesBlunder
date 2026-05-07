/SecretInformation/CursedEnergy
	name = "Cursed Energy"
	maxTier = 5
	givenSkills = list("/obj/Skills/Buffs/SlotlessBuffs/BlackFlash_Potential")
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


mob/proc/getCursedEnergySecret()
	if(hasSecret("Cursed Energy") && istype(secretDatum, /SecretInformation/CursedEnergy))
		return secretDatum

	return null


mob/proc/isCursedEnergyBlackFlashFirstUse()
	var/SecretInformation/CursedEnergy/ce = getCursedEnergySecret()

	if(ce)
		return ce.CursedEnergyBlackFlashFirstTimeUse

	return 0


mob/proc/setCursedEnergyBlackFlashFirstUse()
	var/SecretInformation/CursedEnergy/ce = getCursedEnergySecret()

	if(ce)
		ce.CursedEnergyBlackFlashFirstTimeUse = 0


mob/proc/setupCursedEnergyAwakening()
	var/SecretInformation/CursedEnergy/ce = getCursedEnergySecret()

	if(!ce || ce.awakeningConfigured)
		return

	var/chosenColor = input(src, "Choose aura color.", "Cursed Energy") as color|null
	if(chosenColor)
		cursedEnergyAuraColor = chosenColor

	var/list/traits = list("Serrated", "Electricity", "Slash")
	var/selected = pick(traits)

	cursedEnergyTrait = selected

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

	ce.awakeningConfigured = 1


mob/proc/attemptCursedHeavyStrike()
	if(!getCursedEnergySecret())
		return 0

	if(cursedEnergyTrait == "Electricity")
		var/obj/Skills/AutoHit/Cursed_Voltage_Strike/cvs = findOrAddSkill(/obj/Skills/AutoHit/Cursed_Voltage_Strike)
		if(cvs)
			throwSkill(cvs)
			return 1

	if(cursedEnergyTrait == "Slash")
		var/obj/Skills/AutoHit/Cursed_Technique_Cleave/c = findOrAddSkill(/obj/Skills/AutoHit/Cursed_Technique_Cleave)
		if(c)
			c.adjust(src)
			throwSkill(c)
			return 1

	if(cursedEnergyTrait == "Serrated")
		var/obj/Skills/Queue/Cursed_Technique_Gamblers_Fist/gf = locate(/obj/Skills/Queue/Cursed_Technique_Gamblers_Fist) in src
		if(gf && !gf.Using)
			SetQueue(gf)
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
		if(sd)
			Activate(sd)
			return 1

	if(cursedEnergyTrait == "Slash")
		var/obj/Skills/Projectile/Cursed_Technique_Dismantle/d = findOrAddSkill(/obj/Skills/Projectile/Cursed_Technique_Dismantle)
		if(d)
			d.adjust(src)
			UseProjectile(d)
			return 1

	return 0


mob/proc/attemptCursedReverseDash()
	if(!getCursedEnergySecret())
		return 0

	if(!cursedEnergyDomainChoice)
		return 0

	if(cursedEnergyDomainChoice == "Simple Domain")
		var/obj/Skills/Buffs/SlotlessBuffs/Simple_Domain/sd = locate(/obj/Skills/Buffs/SlotlessBuffs/Simple_Domain) in src
		if(sd)
			sd.Trigger(src)
			return 1

	if(cursedEnergyDomainChoice == "Hollow Wicker Basket")
		var/obj/Skills/Buffs/SlotlessBuffs/Hollow_Wicker_Basket/hwb = locate(/obj/Skills/Buffs/SlotlessBuffs/Hollow_Wicker_Basket) in src
		if(hwb)
			hwb.Trigger(src)
			return 1

	return 0


mob/proc/activateReversedCursedTechnique()
	var/SecretInformation/CursedEnergy/ce = getCursedEnergySecret()

	if(!ce)
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

	var/effectiveMaxHealth = 100 - TotalInjury
	if(HealthCut)
		effectiveMaxHealth -= effectiveMaxHealth * HealthCut
	var/missingHealth = max(0, effectiveMaxHealth - Health)
	var/healAmount = round(missingHealth * healPercent, 0.1)

	if(healAmount > 0)
		HealHealth(healAmount)

	if(TotalInjury > 0)
		HealWounds(TotalInjury * healPercent, 1)

	Maimed = max(0, Maimed - 1)
	HealthCut = max(0, HealthCut - healPercent)
	MaxHealth()

	world << "[src.name] utilizes Reversed Curse Technique and restores their body instantly!"
