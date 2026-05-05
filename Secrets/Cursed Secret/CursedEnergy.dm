/SecretInformation/CursedEnergy
	name = "Cursed Energy"
	maxTier = 5
	givenSkills = list("/obj/Skills/Buffs/SlotlessBuffs/BlackFlash_Potential")

	var/awakeningConfigured = 0
	var/domainChoicePrompted = 0

	proc/updateSlashCursedTechniques(mob/p)
		if(!p || p.cursedEnergyTrait != "Slash")
			return

		var/scale = 1 + (0.5 * max(0, currentTier - 1))

		var/obj/Skills/Queue/Cursed_Technique_Dismantle/d = locate(/obj/Skills/Queue/Cursed_Technique_Dismantle) in p
		if(d)
			d.DamageMult = 3 * scale

		var/obj/Skills/Queue/Cursed_Technique_Cleave/c = locate(/obj/Skills/Queue/Cursed_Technique_Cleave) in p
		if(c)
			c.DamageMult = 4.5 * scale

	proc/grantDomainExpansion(mob/p)
		if(!p)
			return

		var/obj/Skills/Buffs/SlotlessBuffs/Domain_Expansion/d = locate(/obj/Skills/Buffs/SlotlessBuffs/Domain_Expansion) in p
		if(d)
			return

		d = new()
		d.range = 20
		d.useShroud = FALSE

		var/domainName = input(p, "Name your Domain Expansion.", "Domain Name") as text|null
		if(!domainName || !length(domainName))
			domainName = "Unnamed Domain"

		var/icon/customTile = input(p, "Upload a custom Domain floor tile. Optional.", "Domain Tile") as icon|null

		d.demonName = copytext("[domainName]", 1, 65)
		d.customTurfIcon = customTile ? customTile : 'WhiteTurfShift.dmi'
		d.customRoofIcon = null
		d.ActiveMessage = "says: Domain Expansion... [d.demonName]!"
		d.OffMessage = "the domain of [d.demonName] fades..."

		p.AddSkill(d)
		p << "You have gained Domain Expansion!"

		if(!domainChoicePrompted)
			domainChoicePrompted = 1

			var/choice = input(p, "Choose an anti-domain technique:", "Domain Defense") in list("Simple Domain", "Hollow Wicker Basket")

			if(choice == "Simple Domain")
				p.findOrAddSkill(/obj/Skills/Buffs/SlotlessBuffs/Simple_Domain)
				p.cursedEnergyDomainChoice = "Simple Domain"

			else if(choice == "Hollow Wicker Basket")
				p.findOrAddSkill(/obj/Skills/Buffs/SlotlessBuffs/Hollow_Wicker_Basket)
				p.cursedEnergyDomainChoice = "Hollow Wicker Basket"

	proc/chooseSpecialization(mob/p)
		if(!p || p.cursedEnergySpecialization)
			return

		var/choice = input(p, "Choose your specialization.", "Cursed Energy") in list("Reinforcement", "Technique")
		if(!choice)
			choice = "Reinforcement"

		p.cursedEnergySpecialization = choice

		if(choice == "Reinforcement")
			p.passive_handler.Set("CursedReinforcement", 1)
			p << "You specialize in reinforcement."
		else
			p.passive_handler.Set("CursedTechniqueAffinity", 1)
			p << "You specialize in technique control."

	applySecret(mob/p)
		if(!p)
			return

		switch(currentTier)
			if(1)
				p << "You awaken Cursed Energy."
				giveSkills(p)
				p.passive_handler.Set("RenameMana", "Cursed Energy")

				if(prob(10))
					grantDomainExpansion(p)

				nextTierUp = 2

			if(2)
				p << "Your control improves."
				chooseSpecialization(p)

				if(prob(20))
					grantDomainExpansion(p)

				nextTierUp = 3

			if(3)
				p << "Your energy becomes sharper."
				p.passive_handler.Set("Sparks of Black", 0)

				if(prob(35))
					grantDomainExpansion(p)

				nextTierUp = 4

			if(4)
				p << "You unlock Domain Expansion."
				p.passive_handler.Set("Sparks of Black", 0)
				grantDomainExpansion(p)
				nextTierUp = 5

			if(5)
				p << "Your Domain mastery deepens."
				grantDomainExpansion(p)

		updateSlashCursedTechniques(p)


mob
	var
		cursedEnergyAuraColor
		cursedEnergyTrait
		cursedEnergySpecialization
		cursedEnergyDomainChoice


mob/proc/getCursedEnergySecret()
	if(hasSecret("Cursed Energy"))
		return secretDatum
	return null


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
			findOrAddSkill(/obj/Skills/Queue/Cursed_Technique_Dismantle)
			findOrAddSkill(/obj/Skills/Queue/Cursed_Technique_Cleave)
			ce.updateSlashCursedTechniques(src)
			src << "Your cursed energy gains slicing properties."

	ce.awakeningConfigured = 1


mob/proc/attemptCursedHeavyStrike()
	if(!getCursedEnergySecret())
		return 0

	if(cursedEnergyTrait == "Slash")
		var/obj/Skills/Queue/Cursed_Technique_Cleave/c = locate(/obj/Skills/Queue/Cursed_Technique_Cleave) in src
		if(c)
			SetQueue(c)
			return 1

	if(cursedEnergyTrait == "Serrated")
		var/obj/Skills/Queue/Cursed_Technique_Gamblers_Fist/gf = locate(/obj/Skills/Queue/Cursed_Technique_Gamblers_Fist) in src
		if(gf)
			SetQueue(gf)
			return 1

	return 0


mob/proc/attemptCursedToss()
	if(!getCursedEnergySecret())
		return 0

	if(cursedEnergyTrait == "Serrated")
		var/obj/Skills/AutoHit/Shutter_Doors/sd = locate(/obj/Skills/AutoHit/Shutter_Doors) in src
		if(sd)
			Activate(sd)
			return 1

	if(cursedEnergyTrait == "Slash")
		var/obj/Skills/Queue/Cursed_Technique_Dismantle/d = locate(/obj/Skills/Queue/Cursed_Technique_Dismantle) in src
		if(d)
			SetQueue(d)
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

	var/healPercent = 0.065 + (0.015 * (ce.currentTier - 1))

	var/currentHealth = vars["Health"]
	var/maxHealth = vars["MaxHealth"]

	if(!maxHealth)
		maxHealth = currentHealth

	var/healAmount = round(maxHealth * healPercent)
	var/healed = min(maxHealth - currentHealth, healAmount)

	if(healed > 0)
		vars["Health"] = currentHealth + healed

	world << "[src] restores their body using Reverse Cursed Technique."