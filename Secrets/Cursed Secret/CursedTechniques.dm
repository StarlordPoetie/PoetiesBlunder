obj
	Skills
		Queue
			Cursed_Technique_Gamblers_Fist
				SkillCost=0
				Copyable=0
				name="Gamblers Fist"
				DamageMult=9
				AccuracyMult=1.7
				Duration=8
				KBAdd=5
				PushOut=5
				PushOutWaves=3
				InstantStrikes=3
				InstantStrikesDelay=2.3
				Finisher=1
				Warp=5
				Dunker=3
				Stunner=3
				Instinct=2
				UnarmedOnly=1
				EnergyCost=12
				Quaking=2
				Cooldown=30

				verb/Cursed_Technique_Gamblers_Fist()
					set category="Skills"
					set name="Gamblers Fist"
					usr.SetQueue(src)

			// Compatibility shim for saved pre-projectile Dismantle skills.
			// New Cursed Energy users receive /obj/Skills/Projectile/Cursed_Technique_Dismantle.
			Cursed_Technique_Dismantle
				SkillCost=0
				Copyable=0
				name="Dismantle"
				verb/Cursed_Technique_Dismantle()
					set category="Skills"
					set name="Dismantle"
					var/obj/Skills/Projectile/Cursed_Technique_Dismantle/d = usr.findOrAddSkill(/obj/Skills/Projectile/Cursed_Technique_Dismantle)
					usr.UseProjectile(d)

		Projectile
			Cursed_Technique_Dismantle
				SkillCost=0
				Copyable=0
				name="Dismantle"
				ActiveMessage="flicks their finger, unleashing their innate Cursed Technique Dismantle!."
				Distance=30
				DamageMult=3
				AccMult=1.2
				MortalBlow=0.25
				MultiHit=3
				Radius=2
				ZoneAttack=1
				ZoneAttackX=0
				ZoneAttackY=0
				FireFromSelf=1
				FireFromEnemy=0
				Knockback=1
				Slashing=1
				Piercing=1
				EnergyCost=4
				Cooldown=30
				IconLock='Large Dismantle.dmi'
				IconSize=2
				Variation=0

				verb/Cursed_Technique_Dismantle()
					set category="Skills"
					set name="Dismantle"
					usr.UseProjectile(src)

			Cursed_Domain_Dismantle
				SkillCost=0
				Copyable=0
				name="Domain Expansion: Dismantle"
				ActiveMessage="unleashes an unavoidable Dismantle through their Domain!"
				Distance=30
				DamageMult=6
				AccMult=2
				MultiHit=5
				Radius=4
				ZoneAttack=1
				FireFromSelf=1
				Slashing=1
				Piercing=1
				EnergyCost=10
				Cooldown=60
				IconLock='Large Dismantle.dmi'
				IconSize=2

				verb/Cursed_Domain_Dismantle()
					set category="Skills"
					set name="Domain Expansion: Dismantle"
					if(!usr.canUseCursedEnergyDomainSureHit("Slash"))
						return
					usr.UseProjectile(src)

		Buffs
			SlotlessBuffs
				Cursed_Domain_Gamblers_Luck
					SkillCost=0
					Copyable=0
					name="Domain Expansion: Gambler's Luck"
					BuffName="Domain Expansion: Gambler's Luck"
					Slotless=1
					EnergyCost=15
					Cooldown=180
					SpecialAttack=1
					NoLock=1
					NoAttackLock=1
					VaizardHealth=50
					BioArmor=30
					StrMult=2
					EndMult=2
					DefMult=2
					passives = list("UnarmedDamage" = 8, "CriticalChance" = 2, "BlockChance" = 2, "CriticalDamage" = 0.25, "CriticalBlock" = 0.25, "ArmorAscension" = 0.5)
					ActiveMessage="hits the jackpot within their Domain, converting the collapsing barrier into a surge of cursed momentum!"

					Trigger(mob/User, Override=0)
						if(!User || !User.canUseCursedEnergyDomainSureHit("Serrated"))
							return FALSE
						if(User.BuffOn(src))
							User << "Domain Expansion: Gambler's Luck is already active."
							return FALSE
						var/activated = ..()
						if(activated)
							var/obj/Skills/Buffs/SlotlessBuffs/Domain_Expansion/d = locate(/obj/Skills/Buffs/SlotlessBuffs/Domain_Expansion) in User
							User.collapseCursedEnergyDomainSureHit()
							if(d && !d.Using && !d.cooldown_remaining)
								d.Cooldown(p = User)
						return activated

					verb/Cursed_Domain_Gamblers_Luck()
						set category="Skills"
						set name="Domain Expansion: Gambler's Luck"
						Trigger(usr)

		AutoHit
			Cursed_Voltage_Strike
				SkillCost=0
				Copyable=0
				name="Cursed Voltage Strike"
				Area="Strike"
				AdaptRate=1
				Rush=20
				ControlledRush=1
				HomingCharge=1
				SpecialAttack=1
				CanBeDodged=0
				CanBeBlocked=1
				ComboMaster=1
				DamageMult=11
				Stunner=3
				MortalBlow=1
				Knockback=0
				WindUp=0
				ActiveMessage="instantly surges forward with charged electric cursed energy!"
				Icon='Chidori.dmi'
				HitSparkIcon='Hit Effect Vampire.dmi'
				HitSparkX=-32
				HitSparkY=-32
				HitSparkSize=1
				Cooldown=45
				EnergyCost=8
				Instinct=1
				proc/reset2default()
					name="Cursed Voltage Strike"
					Area="Strike"
					AdaptRate=1
					Rush=20
					ControlledRush=1
					HomingCharge=1
					SpecialAttack=1
					CanBeDodged=0
					CanBeBlocked=1
					ComboMaster=1
					DamageMult=11
					Stunner=3
					MortalBlow=1
					Knockback=0
					WindUp=0
					WindupIcon=null
					WindupMessage=null
					ChargeTech=0
					ChargeTime=0
					ActiveMessage="instantly surges forward with charged electric cursed energy!"
					Icon='Chidori.dmi'
					HitSparkIcon='Hit Effect Vampire.dmi'
					HitSparkX=-32
					HitSparkY=-32
					HitSparkSize=1
					Cooldown=45
					EnergyCost=8
					Instinct=1
					Rounds=0
					TurfShift=null
					TurfShiftDuration=0
					TurfShiftDurationSpawn=0
					TurfShiftDurationDespawn=0
				adjust(mob/p)
					reset2default()
					if(!p || p.cursedEnergyTrait != "Electricity")
						return

			Cursed_Domain_Electric_Discharge
				SkillCost=0
				Copyable=0
				name="Domain Expansion: Electric Discharge"
				Area="Circle"
				AdaptRate=1
				SpecialAttack=1
				CanBeDodged=0
				CanBeBlocked=0
				ComboMaster=1
				DamageMult=9
				Stunner=6
				MortalBlow=1
				Rounds=8
				Distance=12
				NoLock=1
				NoAttackLock=1
				ActiveMessage="discharges lightning through their Domain's sure-hit field!"
				Icon='Chidori.dmi'
				HitSparkIcon='Hit Effect Vampire.dmi'
				HitSparkX=-32
				HitSparkY=-32
				HitSparkSize=1
				Cooldown=60
				EnergyCost=10

				verb/Cursed_Domain_Electric_Discharge()
					set category="Skills"
					set name="Domain Expansion: Electric Discharge"
					if(!usr.canUseCursedEnergyDomainSureHit("Electricity"))
						return
					usr.Activate(src)

			Cursed_Technique_Cleave
				SkillCost=0
				Copyable=0
				name="Cleave"
				ActiveMessage="announces Cleave."
				Area="Circle"
				NoLock=1
				NoAttackLock=1
				FlickAttack=1
				StrOffense=1
				DamageMult=4.5
				Stunner=3
				Rounds=5
				DelayTime=0
				Rush=8
				ControlledRush=1
				HomingCharge=1
				Distance=1
				Duration=5
				Cooldown=45
				NeedsSword=0
				EnergyCost=5
				HitSparkIcon='Slash - Zero.dmi'
				HitSparkX=-32
				HitSparkY=-32
				HitSparkSize=0.75
				HitSparkTurns=1

				verb/Cursed_Technique_Cleave()
					set category="Skills"
					set name = "Cleave"
					usr.Activate(src)
			Shutter_Doors
				SkillCost=0
				Copyable=0
				NeedsSword=0
				name="Shutter Doors"
				Area="Around Target"
				AdaptRate=3
				DamageMult=1
				HolyMod=2.5
				AbyssMod=2.5
				Distance=7
				DistanceAround=1
				EnergyCost=10
				Rounds=20
				TurfErupt=0
				TurfEruptOffset=0
				DelayTime=1
				Stunner=6
				ComboMaster=2
				Icon='Cursed_Train_Closing_Doors.dmi'
				Size=0.5
				IconX=0
				IconY=0
				Falling=0
				ActiveMessage="snaps their hands as invisible shutters slam in from all sides, crushing down around the target instantly."
				HitSparkIcon='BLANK.dmi'
				HitSparkX=0
				HitSparkY=0
				Cooldown=30
				Instinct=2

				verb/Shutter_Doors()
					set category="Skills"
					usr.Activate(src)
