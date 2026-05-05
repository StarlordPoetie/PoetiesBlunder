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

			Cursed_Technique_Dismantle
				SkillCost=0
				Copyable=0
				name="Dismantle"
				ActiveMessage="flicks their finger, unleashing Dismantle."
				DamageMult=3
				AccuracyMult=1.2
				InstantStrikes=2
				InstantStrikesDelay=1
				NeedsSword=0
				EnergyCost=4
				Cooldown=30
				HitSparkIcon='Large Dismantle.dmi'
				HitSparkX=-32
				HitSparkY=-32
				HitSparkSize=1.25
				verb/Cursed_Technique_Dismantle()
					set category="Skills"
					set name = "Dismantle"
					var/obj/Skills/Projectile/Divine_Departure/proxy = usr.findOrAddSkill(/obj/Skills/Projectile/Divine_Departure)
					proxy.EnergyCost = src.EnergyCost
					proxy.Cooldown = src.Cooldown
					proxy.DamageMult = src.DamageMult
					proxy.AccMult = src.AccuracyMult
					proxy.MultiHit = src.InstantStrikes
					proxy.HitSparkIcon = src.HitSparkIcon
					proxy.HitSparkX = src.HitSparkX
					proxy.HitSparkY = src.HitSparkY
					usr.UseProjectile(proxy)
			Cursed_Technique_Cleave
				SkillCost=0
				Copyable=0
				name="Cleave"
				ActiveMessage="announces Cleave."
				DamageMult=4.5
				AccuracyMult=1.15
				KBMult=0.00001
				Stunner=3
				InstantStrikes=5
				InstantStrikesDelay=0
				Warp=8
				PushOut=1
				PushOutIcon='BLANK.dmi'
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
					var/obj/Skills/Grapple/Sword/Eviscerate/proxy = usr.findOrAddSkill(/obj/Skills/Grapple/Sword/Eviscerate)
					proxy.DamageMult = src.DamageMult
					proxy.Cooldown = src.Cooldown
					proxy.MultiHit = src.InstantStrikes
					proxy.KBMult = src.KBMult
					proxy.NeedsSword = src.NeedsSword
					proxy.EnergyCost = src.EnergyCost
					proxy.Activate(usr)
		AutoHit
			Shutter_Doors
				NeedsSword=0
				name="Shutter Doors"
				Area="Around Target"
				AdaptRate=3
				DamageMult=1
				HolyMod=2.5
				AbyssMod=2.5
				Distance=1
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