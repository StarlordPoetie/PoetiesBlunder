		CursedEnergy
			name = "Cursed Energy"
			maxTier = 5
			givenSkills = list("/obj/Skills/Buffs/SlotlessBuffs/BlackFlash_Potential")
			var/awakeningConfigured = 0
			proc/chooseSpecialization(mob/p)
				if(!p || p.cursedEnergySpecialization)
					return
				var/list/options = list("Unarmed", "Caster", "Swordsmanship")
				var/selected = input(p, "Choose your Cursed Energy specialization.", "Cursed Energy - Specialization") in options
				if(!selected)
					selected = "Unarmed"
				p.cursedEnergySpecialization = selected
				switch(selected)
					if("Unarmed")
						p.passive_handler.Set("UnarmedDamage", 3)
						p.passive_handler.Set("CriticalDamage", 2)
						p.passive_handler.Set("CriticalChance", 2)
						p.passive_handler.Set("CriticalBlock", 2)
						p.passive_handler.Set("PureReduction", 2)
						p.passive_handler.Set("Flow", 4)
						p.passive_handler.Set("Adrenaline", 3)
						p.passive_handler.Set("Fury", 2)
					if("Caster")
						p.passive_handler.Set("Adrenaline", 3)
						p.passive_handler.Set("MeleeResist", 2)
						p.passive_handler.Set("ManaSteal", 20)
						p.passive_handler.Set("ManaGeneration", 3)
						p.passive_handler.Set("PowerfulCasting", 2)
						p.passive_handler.Set("StalwartCasting", 2)
						p.passive_handler.Set("FluidForm", 3)
						p.passive_handler.Set("Fury", 2)
					if("Swordsmanship")
						p.passive_handler.Set("Fury", 2)
						p.passive_handler.Set("Parry", 2)
						p.passive_handler.Set("Reversal", 2)
						p.passive_handler.Set("Instinct", 4)
						p.passive_handler.Set("SwordDamage", 2)
						p.passive_handler.Set("Adrenaline", 3)
						p.passive_handler.Set("SwordAscension", 1)
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
				var/obj/Skills/Buffs/SlotlessBuffs/Domain_Expansion/d = locate(/obj/Skills/Buffs/SlotlessBuffs/Domain_Expansion) in p.Buffs
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
			applySecret(mob/p)
				switch(currentTier)
					if(1)
						p << "You awaken to the flow of Cursed Energy."
						giveSkills(p) // Keep T1 Black Flash access (120% Potential buff)
						p.passive_handler.Set("RenameMana", "Cursed Energy")
						if(prob(10))
							grantDomainExpansion(p)
						nextTierUp = 3
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
						p.findOrAddSkill(/obj/Skills/Buffs/SlotlessBuffs/Hollow_Wicker_Basket)
						p.findOrAddSkill(/obj/Skills/Buffs/SlotlessBuffs/Simple_Domain)
						grantDomainExpansion(p)
						nextTierUp = 4
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

	proc
		getCursedEnergySecret()
			if(hasSecret("Cursed Energy")) return secretDatum
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
						src << "Your cursed energy obtains the unique property of <b>serrating</b> your opponents on hit."
					if("Electricity")
						passive_handler.Set("FavoredPrey", "Saga")
						src << "Your cursed energy obtains the unique property of <b>electrifying</b> your opponents on hit."
					if("Slash")
						passive_handler.Set("FavoredPrey", "All")
						findOrAddSkill(/obj/Skills/Queue/Cursed_Technique_Dismantle)
						findOrAddSkill(/obj/Skills/Queue/Cursed_Technique_Cleave)
						var/SecretInformation/CursedEnergy/ce2 = getCursedEnergySecret()
						if(ce2) ce2.updateSlashCursedTechniques(src)
						src << "Your cursed energy obtains the unique property of <b>slashing</b> your opponents on hit."
			ce.awakeningConfigured = 1
