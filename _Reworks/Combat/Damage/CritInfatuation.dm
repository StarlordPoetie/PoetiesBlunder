/mob/proc/getInfatuation(mob/defender)
	for(var/obj/Skills/Buffs/SlotlessBuffs/Autonomous/buff in src)
		if(buff.passives["Infatuated"]&&buff.Password == defender?:UniqueID)
			return 1+buff.passives["Infatuated"]
	return 1
/mob/proc/getCritAndBlock(mob/defender, damage)
	var/critChance = passive_handler.Get("CriticalChance")
	var/critDMG = passive_handler.Get("CriticalDamage")
	var/denkoCharge = DenkoSekkaCharged
	if(denkoCharge)
		critChance += denkoCharge * glob.DENKO_SEKKA_CRIT_CHANCE_PER_LEVEL
		DenkoSekkaCharged = 0
	var/blockChance = 0
	var/critBlock = 0
	if(passive_handler["Determination(Red)"]||passive_handler["Determination(White)"])
		critChance+=(ManaAmount/4)
	if(defender)
		blockChance = defender.passive_handler.Get("BlockChance")
		critBlock = defender.passive_handler.Get("CriticalBlock")
	var/martialStyle = usingStyle("UnarmedStyle")
	var/defenderMartialStyle = defender.usingStyle("UnarmedStyle")
	if(martialStyle)
		critChance += 5 + (2.5 * StyleBuff.SignatureTechnique)
		critDMG += 0.05 + (0.05 * StyleBuff.SignatureTechnique)
		if(Saga && SagaLevel)
			critChance += 5 + (2.5 * SagaLevel)
			critDMG += 0.1 + (0.05 * SagaLevel)
	if(defender)
		if(defenderMartialStyle)
			blockChance += 5 + (5 * defender.StyleBuff.SignatureTechnique)
			critBlock += 0.05 + (0.05 * defender.StyleBuff.SignatureTechnique)
			if(defender.Saga && defender.SagaLevel)
				blockChance += 5 + (2.5 * defender.SagaLevel)
				critBlock += 0.1 + (0.05 * defender.SagaLevel)
	var/didCrit = prob(critChance)
	if(didCrit && denkoCharge)
		critDMG += denkoCharge * glob.DENKO_SEKKA_CRIT_DAMAGE_PER_LEVEL
	if(didCrit)
		if(!AttackQueue)
			if(passive_handler["ThunderHerald"])
				var/obj/Skills/s = findOrAddSkill(/obj/Skills/AutoHit/Thunder_Bolt)
				s.adjust(src)
				Activate(s)
			if(passive_handler["IceHerald"])
				var/obj/Skills/s = findOrAddSkill(/obj/Skills/AutoHit/Icy_Wind)
				s.adjust(src)
				Activate(s)
			if(passive_handler["DemonicInfusion"])
				var/obj/Skills/s = findOrAddSkill(/obj/Skills/AutoHit/HellfireRain)
				s.adjust(src)
				Activate(s)
			if(src.Class=="Reaper")
				if(prob(critChance/10))
					var/obj/Skills/s = findOrAddSkill(/obj/Skills/AutoHit/Blossom_Shower)
					s.adjust(src)
					Activate(s)
		if(passive_handler["Determination(Red)"] && ManaAmount>=75||passive_handler["Determination(White)"] && ManaAmount>=75)
			if(SagaLevel<4||RebirthHeroType=="Red")
				critDMG+= ManaAmount/100
				if(SagaLevel==3&&!passive_handler["UnleashToggle"])
					var/obj/Skills/s = findOrAddSkill(/obj/Skills/AutoHit/Unleash)
					s.adjust(src)
					Activate(s)
			if(SagaLevel>=4&&RebirthHeroType!="Red")
				if(ManaAmount<98)
					critDMG+= ManaAmount/150
				if(ManaAmount>=98)
					critDMG+= ManaAmount/33
					if(!passive_handler["UnleashToggle"])
						var/obj/Skills/s = findOrAddSkill(/obj/Skills/AutoHit/Unleash)
						s.adjust(src)
						Activate(s)
					if(SagaLevel<5)
						ManaAmount=0
					if(SagaLevel>=5&&ManaAmount>=150)
						ManaAmount-=50
			if(SagaLevel<4||RebirthHeroType=="Red")
				ManaAmount=0
		damage *= 1+critDMG
	if(prob(blockChance))
		damage /= 1+critBlock
	return damage
