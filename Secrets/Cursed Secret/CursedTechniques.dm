obj
	Skills
		Queue
			Cursed_Technique_Gamblers_Fist
				SkillCost=0
				Copyable=0
				CursedTechnique=1
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
				ManaCost=12
				Quaking=2
				Cooldown=30

				verb/Cursed_Technique_Gamblers_Fist()
					set category="Skills"
					set hidden=1
					set name="Gamblers Fist"
					usr.SetQueue(src)

			Cursed_Technique_Dismantle
				SkillCost=0
				Copyable=0
				CursedTechnique=1
				name="Dismantle"

				verb/Cursed_Technique_Dismantle()
					set category="Skills"
					set hidden=1
					set name="Dismantle"
					var/obj/Skills/Projectile/Cursed_Technique_Dismantle/d = usr.findOrAddSkill(/obj/Skills/Projectile/Cursed_Technique_Dismantle)
					usr.UseProjectile(d)

		Projectile
			Cursed_Technique_Dismantle
				SkillCost=0
				Copyable=0
				CursedTechnique=1
				name="Dismantle"
				ActiveMessage="flicks their finger, unleashing their innate Cursed Technique Dismantle!"
				Distance=30
				DamageMult=3
				AccMult=1.2
				MortalBlow=0.5
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
				ManaCost=4
				Cooldown=30
				IconLock='Large Dismantle.dmi'
				IconSize=2
				Variation=0

				verb/Cursed_Technique_Dismantle()
					set category="Skills"
					set hidden=1
					set name="Dismantle"
					usr.UseProjectile(src)

			Cursed_Domain_Dismantle
				SkillCost=0
				Copyable=0
				CursedTechnique=1
				name="Domain Expansion: Dismantle"

				verb/Cursed_Domain_Dismantle()
					set category="Skills"
					set name="Domain Expansion: Dismantle"
					var/obj/Skills/AutoHit/Cursed_Domain_Dismantle/d = usr.findOrAddSkill(/obj/Skills/AutoHit/Cursed_Domain_Dismantle)
					if(!d || !usr.canUseCursedEnergyDomainSureHit("Slash"))
						return
					if(usr.Activate(d))
						usr.finishCursedEnergyDomainSureHit(d)

			Cursed_Technique_Hollow_Purple
				SkillCost=0
				Copyable=0
				CursedTechnique=1
				name="Hollow Purple"
				ActiveMessage="fuses Red and Blue into Hollow Purple!"
				Distance=40
				DamageMult=2.5
				AccMult=1.5
				MultiHit=19
				Radius=3
				ZoneAttack=5
				FireFromSelf=1
				Knockback=50
				PullIn=8
				Homing=1
				HyperHoming=1
				HomingCharge=4
				LosesHoming=40
				Deflectable=-1
				ManaCost=28
				Cooldown=130
				IconLock='HollowPurple.dmi'
				IconSize=4
				Trail='dark_GalaxyTurfshift.dmi'
				Variation=0

				proc/adjustCursedHollowPurple(mob/p)
					if(p)
						p.updateCursedEnergySpatialTechniques()

				verb/Hollow_Purple()
					set category="Skills"
					set hidden=1
					usr.UseProjectile(src)

			Cursed_Technique_Maximum_Meteor
				SkillCost=0
				Copyable=0
				CursedTechnique=1
				name="Maximum Meteor"
				ActiveMessage="summons a falling Maximum Meteor!"
				Distance=35
				DamageMult=8
				AccMult=1.1
				Radius=6
				ZoneAttack=1
				FireFromEnemy=1
				Homing=1
				FireFromSelf=0
				Hover=20
				Knockback=10
				Stunner=5
				Scorching=52
				Burning=8
				TurfShift='LavaTile.dmi'
				Deflectable=-1
				ManaCost=26
				Cooldown=100
				IconLock='DoomMeteor.dmi'
				IconSize=2
				Trail='TrailFire.dmi'
				Variation=0

				proc/adjustCursedMaximumMeteor(mob/p)
					if(p)
						p.updateCursedEnergyImmolationTechniques()

				verb/Maximum_Meteor()
					set category="Skills"
					set hidden=1
					usr.UseProjectile(src)

		Buffs
			SlotlessBuffs
				Cursed_Domain_Gamblers_Luck
					SkillCost=0
					Copyable=0
					CursedTechnique=1
					name="Domain Expansion: Gambler's Luck"
					BuffName="Domain Expansion: Gambler's Luck"
					Slotless=1
					ManaCost=15
					TimerLimit=150
					Cooldown=180
					VaizardHealth=50
					BioArmor=30
					StrMult=2
					EndMult=2
					DefMult=2
					passives=list("UnarmedDamage"=8, "CriticalChance"=2, "BlockChance"=2, "CriticalDamage"=0.25, "CriticalBlock"=0.25, "ArmorAscension"=0.5)
					ActiveMessage="hits the jackpot within their Domain, converting the collapsing barrier into a surge of cursed momentum!"

					GainLoop(mob/User)
						..()
						if(User && User.BuffOn(src))
							User.ManaAmount=1000000000
							User.MaxMana()

					Trigger(mob/User, Override=0)
						if(!User)
							return FALSE
						if(User.BuffOn(src))
							if(Override)
								return ..()
							User << "Domain Expansion: Gambler's Luck is already active."
							return FALSE
						if(!User.canUseCursedEnergyDomainSureHit("Serrated"))
							return FALSE
						var/activated=..()
						if(activated)
							var/obj/Skills/Buffs/SlotlessBuffs/Domain_Expansion/d = locate(/obj/Skills/Buffs/SlotlessBuffs/Domain_Expansion) in User
							User.collapseCursedEnergyDomainSureHit()
							if(d && !d.Using && !d.cooldown_remaining)
								d.Cooldown(p=User)
						return activated

					verb/Cursed_Domain_Gamblers_Luck()
						set category="Skills"
						set name="Domain Expansion: Gambler's Luck"
						Trigger(usr)

				Limitless
					SkillCost=0
					Copyable=0
					CursedTechnique=1
					name="Limitless"
					BuffName="Limitless"
					Slotless=1
					ManaDrain=1.5
					ManaThreshold=1
					IconLock='Limitless_Smooth_Barrier.dmi'
					LockX=-16
					LockY=-16
					IconLockBlend=1
					TopOverlayLock='BlueSixEyes.dmi'
					passives=list("PureReduction"=9, "Deflection"=7, "BulletKill"=6, "Void"=1, "VenomImmune"=1, "InjuryImmune"=1, "DebuffResistance"=6, "Juggernaut"=6, "Reversal"=6)
					ActiveMessage="lets infinity divide the space around them."
					OffMessage="allows the Limitless barrier to fall away."

					Trigger(mob/User, Override=0)
						var/activated=..()
						if(User)
							User.updateCursedEnergySixEyesOverlay()
						return activated

					GainLoop(mob/User)
						ManaDrain=1.5
						if(User && User.cursedEnergySixEyes)
							ManaDrain=0.2
						..()
						if(User)
							User.updateCursedEnergySixEyesOverlay()

					verb/Limitless()
						set category="Skills"
						set name="Limitless"
						Trigger(usr)

				Disaster_Flames
					SkillCost=0
					Copyable=0
					CursedTechnique=1
					name="Disaster Flames"
					BuffName="Disaster Flames"
					Slotless=1
					ManaDrain=1
					ManaThreshold=1
					IconLock='Aura_supernova.dmi'
					LockX=-32
					LockY=-32
					passives=list("PureDamage"=2, "Scorching"=5, "Burning"=3, "FireHerald"=1)
					ActiveMessage="erupts in Disaster Flames."
					OffMessage="lets the Disaster Flames gutter out."

					GainLoop(mob/User)
						..()
						if(!User || !User.BuffOn(src))
							return
						var/SecretInformation/CursedEnergy/ce = User.getCursedEnergySecret()
						var/tier = ce ? max(1, ce.currentTier) : 1
						for(var/mob/m in oview(2, User))
							if(!m || m == User)
								continue
							if(User.party && (m in User.party.members))
								continue
							if(!m.client && !isAI(m))
								continue
							m.AddBurn(1 + tier, User)
							User.DoDamage(m, TrueDamage(0.4 + (tier * 0.15)))

					verb/Disaster_Flames()
						set category="Skills"
						set name="Disaster Flames"
						Trigger(usr)

		AutoHit
			Cursed_Domain_Dismantle
				SkillCost=0
				Copyable=0
				CursedTechnique=1
				NeedsSword=0
				name="Domain Expansion: Dismantle"
				ActiveMessage="unleashes a barrage of unavoidable Dismantles through their Domain!"
				Area="Circle"
				StrOffense=1.5
				Cooldown=180
				DamageMult=0.8
				Rounds=80
				MortalWound=0.3
				PushOutWaves=8
				ComboMaster=1
				Size=14
				ManaCost=30
				Icon='BLANK.dmi'
				IconX=-32
				IconY=-32
				HitSparkIcon='Slash_-_Ragna.dmi'
				HitSparkX=-16
				HitSparkY=-16
				HitSparkTurns=1
				HitSparkSize=1
				HitSparkDispersion=1
				TurfStrike=1

				verb/Cursed_Domain_Dismantle()
					set category="Skills"
					set name="Domain Expansion: Dismantle"
					if(!usr.canUseCursedEnergyDomainSureHit("Slash"))
						return
					if(usr.Activate(src))
						usr.finishCursedEnergyDomainSureHit(src)

			Cursed_Voltage_Strike
				SkillCost=0
				Copyable=0
				CursedTechnique=1
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
				ManaCost=8
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
					ManaCost=8
					Instinct=1
					Rounds=0
					TurfShift=null
					TurfShiftDuration=0
					TurfShiftDurationSpawn=0
					TurfShiftDurationDespawn=0

				proc/adjustCursedVoltageStrike(mob/p)
					reset2default()
					if(!p || p.cursedEnergyTrait != "Electricity")
						return

			Cursed_Domain_Electric_Discharge
				SkillCost=0
				Copyable=0
				CursedTechnique=1
				name="Domain Expansion: Electric Discharge"
				Area="Circle"
				AdaptRate=1
				SpecialAttack=1
				CanBeDodged=0
				CanBeBlocked=0
				ComboMaster=1
				DamageMult=9
				Bolt=2
				BoltOffset=1
				Rounds=8
				Distance=12
				NoLock=1
				NoAttackLock=1
				ActiveMessage="discharges lightning through their Domain's sure-hit field!"
				Icon='Chidori.dmi'
				HitSparkIcon='ElecAura8.dmi'
				HitSparkX=-32
				HitSparkY=-32
				HitSparkSize=1
				Cooldown=60
				ManaCost=10

				verb/Cursed_Domain_Electric_Discharge()
					set category="Skills"
					set name="Domain Expansion: Electric Discharge"
					if(!usr.canUseCursedEnergyDomainSureHit("Electricity"))
						return
					if(usr.Activate(src))
						usr.finishCursedEnergyDomainSureHit(src)

			Cursed_Technique_Cleave
				SkillCost=0
				Copyable=0
				CursedTechnique=1
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
				MortalBlow=0.5
				DelayTime=0
				Rush=8
				ControlledRush=1
				HomingCharge=1
				Distance=1
				Duration=5
				Cooldown=45
				NeedsSword=0
				ManaCost=5
				HitSparkIcon='Slash - Zero.dmi'
				HitSparkX=-32
				HitSparkY=-32
				HitSparkSize=0.75
				HitSparkTurns=1

				verb/Cursed_Technique_Cleave()
					set category="Skills"
					set hidden=1
					set name="Cleave"
					usr.Activate(src)

			Shutter_Doors
				SkillCost=0
				Copyable=0
				CursedTechnique=1
				NeedsSword=0
				name="Shutter Doors"
				Area="Around Target"
				AdaptRate=3
				DamageMult=1
				HolyMod=2.5
				AbyssMod=2.5
				Distance=7
				DistanceAround=1
				ManaCost=10
				Rounds=20
				TurfErupt=0
				TurfEruptOffset=0
				DelayTime=1
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
					set hidden=1
					usr.Activate(src)

			Cursed_Technique_Red
				SkillCost=0
				Copyable=0
				CursedTechnique=1
				NeedsSword=0
				name="Cursed Technique Reversal: Red"
				ActiveMessage="condenses reversed cursed energy into Repulsion: Red!"
				Area="Strike"
				AdaptRate=1
				SpecialAttack=1
				CanBeDodged=1
				CanBeBlocked=1
				ComboMaster=1
				DamageMult=11
				Stunner=2
				Knockback=30
				Earthshaking=3
				Distance=2
				Cooldown=60
				ManaCost=14
				Icon='CursedTechnique_Red.dmi'
				HitSparkIcon='Icons/GojoHitspark.dmi'
				HitSparkX=-32
				HitSparkY=-32
				HitSparkSize=1
				LockOut=list("/obj/Skills/AutoHit/Cursed_Technique_Blue")

				proc/adjustCursedTechniqueRed(mob/p)
					if(p)
						p.updateCursedEnergySpatialTechniques()

				verb/Cursed_Technique_Red()
					set category="Skills"
					set hidden=1
					usr.Activate(src)

			Cursed_Technique_Blue
				SkillCost=0
				Copyable=0
				CursedTechnique=1
				NeedsSword=0
				name="Cursed Technique Lapse: Blue"
				ActiveMessage="collapses the space ahead with Attraction: Blue!"
				Area="Circle"
				AdaptRate=1
				SpecialAttack=1
				CanBeDodged=1
				CanBeBlocked=1
				ComboMaster=1
				DamageMult=7
				Stunner=5
				PullIn=20
				Distance=25
				Size=2
				Rounds=3
				Earthshaking=5
				Cooldown=60
				ManaCost=12
				Icon='TrippyPurpleBlue.dmi'
				HitSparkIcon='GojoHitspark.dmi'
				HitSparkX=-32
				HitSparkY=-32
				HitSparkSize=1
				LockOut=list("/obj/Skills/AutoHit/Cursed_Technique_Red")

				proc/adjustCursedTechniqueBlue(mob/p)
					if(p)
						p.updateCursedEnergySpatialTechniques()

				verb/Cursed_Technique_Blue()
					set category="Skills"
					set hidden=1
					usr.Activate(src)

			Cursed_Technique_Volcanic_Strike
				SkillCost=0
				Copyable=0
				CursedTechnique=1
				NeedsSword=0
				name="Volcanic Strike"
				ActiveMessage="drives volcanic cursed flames into the ground!"
				Area="Circle"
				AdaptRate=1
				SpecialAttack=1
				CanBeDodged=1
				CanBeBlocked=1
				DamageMult=6
				Stunner=3
				Distance=2
				Size=3
				Rounds=3
				Scorching=28
				Burning=4
				Knockback=4
				Quaking=2
				TurfShift='LavaTile.dmi'
				TurfShiftDuration=80
				TurfShiftDurationSpawn=8
				TurfShiftDurationDespawn=8
				Cooldown=35
				ManaCost=12
				Icon='Fire VFX10.dmi'
				HitSparkIcon='fevExplosion - Hellfire.dmi'
				HitSparkX=-32
				HitSparkY=-32
				HitSparkSize=1

				proc/adjustCursedVolcanicStrike(mob/p)
					if(p)
						p.updateCursedEnergyImmolationTechniques()

				verb/Volcanic_Strike()
					set category="Skills"
					set hidden=1
					usr.Activate(src)

			Cursed_Domain_Infinite_Void
				SkillCost=0
				Copyable=0
				CursedTechnique=1
				name="Domain Expansion: Infinite Void"
				ActiveMessage="floods the Domain with the endless information of Infinite Void!"
				Area="Circle"
				AdaptRate=1
				SpecialAttack=1
				CanBeDodged=0
				CanBeBlocked=0
				DamageMult=0.1
				Stunner=15
				Rounds=10
				Distance=15
				NoLock=1
				NoAttackLock=1
				Cooldown=30
				ManaCost=10
				Icon='BLANK.dmi'
				HitSparkIcon='TrippyPurpleBlue.dmi'
				HitSparkX=-32
				HitSparkY=-32

				verb/Cursed_Domain_Infinite_Void()
					set category="Skills"
					set name="Domain Expansion: Infinite Void"
					if(!usr.canUseCursedEnergyDomainSureHit("Spatial Manipulation"))
						return
					if(usr.Activate(src))
						usr.finishCursedEnergyDomainSureHit(src)