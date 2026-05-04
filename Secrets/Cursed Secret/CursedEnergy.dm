	CursedEnergy
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
			var/obj/Skills/Buffs/SlotlessBuffs/Domain_Expansion/d = locate(/obj/Skills/Buffs/SlotlessBuffs/Domain_Expansion) in p
			if(d)
				return
			d = new()
			d.range = 20
			d.useShroud = FALSE
			var/domainName = input(p, "Name your Domain Expansion.", "Cursed Energy - Domain Name") as text|null
			if(!domainName || !length(domainName))
				domainName = "Unnamed Domain"
			var/icon/customTile = input(p, "Upload a custom Domain floor tile icon? (Optional)", "Cursed Energy - Domain Tile", null) as icon|null
			d.demonName = copytext("[domainName]", 1, 65)
			d.customTurfIcon = customTile ? customTile : 'WhiteTurfShift.dmi'
			d.customRoofIcon = null
			d.ActiveMessage = "says: Domain Expansion.. [d.demonName]!"
			d.OffMessage = "conceals the domain of [d.demonName]..."
			p.AddSkill(d)
			p << "You have gained Domain Expansion!"
			// Prompt for anti-domain skill choice
			if(!domainChoicePrompted)
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
		proc/chooseSpecialization(mob/p)
			if(!p)
				return
			if(p.cursedEnergySpecialization)
				return
			var/list/options = list("Reinforcement", "Technique")
			var/choice = input(p, "Choose your Cursed Energy specialization.", "Cursed Energy - Specialization") in options
			if(!choice)
				choice = "Reinforcement"
			p.cursedEnergySpecialization = choice
			if(choice == "Reinforcement")
				p.passive_handler.Set("CursedReinforcement", 1)
				p << "You focus on amplifying your body through Cursed Energy reinforcement."
			else
				p.passive_handler.Set("CursedTechniqueAffinity", 1)
				p << "You focus on refined control for Cursed Technique output."
		proc/applySecret(mob/p)
			switch(currentTier)
				if(1)
					p << "You awaken to the flow of Cursed Energy."
					giveSkills(p) // Keep T1 Black Flash access (120% Potential buff)
					p.passive_handler.Set("RenameMana", "Cursed Energy")
					if(prob(10))
						grantDomainExpansion(p)
					nextTierUp = 2
				if(2)
					p << "Your Cursed Energy control improves."
					chooseSpecialization(p)
					if(prob(20))
						grantDomainExpansion(p)
					nextTierUp = 3
				if(3)
					p << "Your Cursed Energy grows denser and more precise."
					p.passive_handler.Set("Sparks of Black", 0)
					for(var/obj/Skills/Buffs/SlotlessBuffs/BlackFlash_SureStrike/ss in p.Buffs)
						p.Buffs -= ss
						del(ss)
					if(prob(35))
						grantDomainExpansion(p)
					nextTierUp = 4
				if(4)
					p << "Your Cursed Energy reaches a breakthrough: Domain Expansion is now yours by default."
					p.passive_handler.Set("Sparks of Black", 0)
					grantDomainExpansion(p)
					nextTierUp = 5
				if(5)
					p << "Your Domain mastery deepens."
					p.passive_handler.Set("Sparks of Black", 0)
					grantDomainExpansion(p)
			updateSlashCursedTechniques(p)


mob
	var
		cursedEnergyAuraColor
		cursedEnergyTrait
		cursedEnergySpecialization
		cursedEnergyDomainChoice

	proc
		getCursedEnergySecret()
			if(hasSecret("Cursed Energy"))
				return secretDatum
			return null

		setupCursedEnergyAwakening()
			var/SecretInformation/CursedEnergy/ce = getCursedEnergySecret()
			if(!ce || ce.awakeningConfigured)
				return

			var/chosenColor = input(src, "Choose your Cursed Energy aura color.", "Cursed Energy - Aura Color", rgb(120, 80, 200)) as color|null
			if(chosenColor)
				cursedEnergyAuraColor = chosenColor

			var/list/availableTraits = list("Serrated", "Electricity", "Slash")

			for(var/trait in cursed_energy_taken_traits)
				availableTraits -= trait

			if(!availableTraits.len)
				src << "No unique Cursed Energy traits remain to be awakened."
				ce.awakeningConfigured = 1
				return

			var/selectedTrait = pick(availableTraits)
			cursed_energy_taken_traits += selectedTrait
			cursedEnergyTrait = selectedTrait

			switch(selectedTrait)
				if("Serrated")
					passive_handler.Set("FavoredPrey", "Mortal")
					findOrAddSkill(/obj/Skills/Queue/Cursed_Technique_Gamblers_Fist)
					findOrAddSkill(/obj/Skills/AutoHit/Shutter_Doors)
					src << "Your cursed energy obtains the unique property of serrating your opponents on hit."

				if("Electricity")
					passive_handler.Set("FavoredPrey", "Saga")
					src << "Your cursed energy obtains the unique property of electrifying your opponents on hit."

				if("Slash")
					passive_handler.Set("FavoredPrey", "All")
					findOrAddSkill(/obj/Skills/Queue/Cursed_Technique_Dismantle)
					findOrAddSkill(/obj/Skills/Queue/Cursed_Technique_Cleave)
					ce.updateSlashCursedTechniques(src)
					src << "Your cursed energy obtains the unique property of slashing your opponents on hit."

			ce.awakeningConfigured = 1

		attemptCursedHeavyStrike()
			if(!getCursedEnergySecret())
				return 0

			if(cursedEnergyTrait == "Serrated")
				var/obj/Skills/Queue/Cursed_Technique_Gamblers_Fist/gf = locate(/obj/Skills/Queue/Cursed_Technique_Gamblers_Fist) in src
				if(gf)
					SetQueue(gf)
					return 1

			if(cursedEnergyTrait == "Slash")
				var/obj/Skills/Queue/Cursed_Technique_Cleave/c = locate(/obj/Skills/Queue/Cursed_Technique_Cleave) in src
				if(c)
					SetQueue(c)
					return 1

			return 0

		attemptCursedToss()
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

		attemptCursedReverseDash()
			if(!getCursedEnergySecret())
				return 0
			if(!cursedEnergyDomainChoice)
				return 0

			if(cursedEnergyDomainChoice == "Simple Domain")
				var/obj/Skills/Buffs/SlotlessBuffs/Simple_Domain/sd = locate(/obj/Skills/Buffs/SlotlessBuffs/Simple_Domain) in Buffs
				if(sd)
					sd.Trigger(src)
					return 1

			if(cursedEnergyDomainChoice == "Hollow Wicker Basket")
				var/obj/Skills/Buffs/SlotlessBuffs/Hollow_Wicker_Basket/hwb = locate(/obj/Skills/Buffs/SlotlessBuffs/Hollow_Wicker_Basket) in Buffs
				if(hwb)
					hwb.Trigger(src)
					return 1

			return 0

		activateReversedCursedTechnique()
			var/SecretInformation/CursedEnergy/ce = getCursedEnergySecret()
			if(!ce)
				return

			var/healPercent = 0.065

			switch(ce.currentTier)
				if(1)
					healPercent = 0.065
				if(2)
					healPercent = 0.08
				if(3)
					healPercent = 0.095
				if(4)
					healPercent = 0.11
				if(5)
					healPercent = 0.125

			var/currentHealth = vars["Health"]
			var/maximumHealth = vars["MaxHealth"]

			if(!maximumHealth)
				maximumHealth = currentHealth

			var/healAmount = round(maximumHealth * healPercent)
			var/healedAmount = min(maximumHealth - currentHealth, healAmount)

			if(healedAmount > 0)
				vars["Health"] = currentHealth + healedAmount

			world << "[src] utilizes Reverse Cursed Technique to heal their body."