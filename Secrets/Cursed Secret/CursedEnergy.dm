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
	proc/grantDomainExpansion(mob/p)
		if(!p)
			return
		var/obj/Skills/Buffs/SlotlessBuffs/Domain_Expansion/d = locate(/obj/Skills/Buffs/SlotlessBuffs/Domain_Expansion) in p
		if(d)
			grantDomainDefense(p)
			return
		var/demonName = input(p, "What is the name of your Domain? (e.g. 'Malevolent Shrine' -> activation says 'X says: Domain Expansion.. Malevolent Shrine')", "Domain Expansion - Name") as text|null
		if(!demonName || !length(demonName))
			demonName = "Unnamed Domain"
		var/icon/customTurfIcon = input(p, "Upload the custom floor icon for the Domain (32x32 .dmi, single state).", "Domain Expansion - Turf Icon") as icon|null
		if(!customTurfIcon)
			customTurfIcon = 'WhiteTurfShift.dmi'
		var/rawRange = input(p, "Range of the Domain Expansion (1 to 50).", "Domain Expansion - Range", 20) as num|null
		var/finalRange = 20
		if(!isnull(rawRange))
			finalRange = round(rawRange)
		if(finalRange < 1) finalRange = 1
		if(finalRange > 50) finalRange = 50
		var/shroudChoice = input(p, "Should the Domain use a shroud overlay on top of the floor? (Selecting No leaves only the custom floor.)", "Domain Expansion - Shroud") in list("Yes","No")
		var/useShroud = (shroudChoice == "Yes")
		var/icon/customRoofIcon = null
		if(useShroud)
			customRoofIcon = input(p, "Upload the custom shroud icon for the Domain (32x32 .dmi, single state). Cancel to fall back to the default Roofs.dmi shroud.", "Domain Expansion - Shroud Icon") as icon|null
		d = new()
		d.demonName = copytext("[demonName]", 1, 65)
		d.customTurfIcon = customTurfIcon
		d.customRoofIcon = customRoofIcon
		d.useShroud = useShroud
		d.range = finalRange
		d.ActiveMessage = "says: Domain Expansion.. [d.demonName]!"
		d.OffMessage = "conceals the domain of [d.demonName]..."
		p.AddSkill(d)
		p << "You have gained Domain Expansion ([d.demonName], range [finalRange], shroud [useShroud ? "on" : "off"])."
		grantDomainDefense(p)
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
		switch(choice)
			if("Cursed Energy Reinforcement")
				p.passive_handler.Set("Cursed Energy Reinforcement", 1)
				p.passive_handler.Set("UnarmedDamage", 3)
				p.passive_handler.Set("CriticalDamage", 2)
				p.passive_handler.Set("CriticalChance", 2)
				p.passive_handler.Set("CriticalBlock", 2)
				p.passive_handler.Set("PureReduction", 2)
				p.passive_handler.Set("Flow", 4)
				p.passive_handler.Set("Adrenaline", 3)
				p.passive_handler.Set("Fury", 2)
				p << "You focus on Cursed Energy Reinforcement, hardening body and impact."
			if("Cursed Energy Enrichment")
				p.passive_handler.Set("Cursed Energy Enrichment", 1)
				p.passive_handler.Set("Adrenaline", 3)
				p.passive_handler.Set("MeleeResist", 2)
				p.passive_handler.Set("ManaSteal", 20)
				p.passive_handler.Set("ManaGeneration", 3)
				p.passive_handler.Set("PowerfulCasting", 2)
				p.passive_handler.Set("StalwartCasting", 2)
				p.passive_handler.Set("FluidForm", 3)
				p.passive_handler.Set("Fury", 2)
				p << "You focus on Cursed Energy Enrichment, improving flow and technique conversion."
			if("Cursed Energy Enhancement")
				p.passive_handler.Set("Cursed Energy Enhancement", 1)
				p.passive_handler.Set("Fury", 2)
				p.passive_handler.Set("Parry", 2)
				p.passive_handler.Set("Reversal", 2)
				p.passive_handler.Set("Instinct", 4)
				p.passive_handler.Set("SwordDamage", 2)
				p.passive_handler.Set("Adrenaline", 3)
				p.passive_handler.Set("SwordAscension", 1)
				p << "You focus on Cursed Energy Enhancement, sharpening weapon flow and reactions."
	proc/applySecret(mob/p)
		if(!p)
			return
		removeBlackFlashSureStrike(p)
		p.applyCursedEnergyKiControlDefaults()
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
		ki.applyCursedEnergyDefaults()


mob
	var
		cursedEnergyAuraColor
		cursedEnergyTrait
		cursedEnergySpecialization
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
