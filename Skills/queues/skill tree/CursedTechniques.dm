obj
	Skills
		Queue
			Cursed_Technique_Gamblers_Fist
				SkillCost=0
				Copyable=0
				name="Gamblers Fist"
				DamageMult=9
				AccuracyMult = 1.7
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
					set name = "Gamblers Fist"
					usr.SetQueue(src)
			Cursed_Technique_Dismantle
				SkillCost=0
				Copyable=0
				ActiveMessage="unleashes Dismantle!"
				DamageMult=3
				AccuracyMult=1.2
				InstantStrikes=2
				InstantStrikesDelay=1
				NeedsSword=0
				EnergyCost=4
				Cooldown=30
				HitSparkIcon='Slash - Zero.dmi'
				HitSparkX=-32
				HitSparkY=-32
				HitSparkSize=1.25
				verb/Cursed_Technique_Dismantle()
					set category="Skills"
					set name = "Dismantle"
					usr.SetQueue(src)
			Cursed_Technique_Cleave
				SkillCost=0
				Copyable=0
				ActiveMessage="prepares Cleave!"
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
					usr.SetQueue(src)
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
				Icon='BLANK.dmi'
				Size=0.1
				IconX=0
				IconY=0
				Falling=0
				ActiveMessage="snaps their hands as invisible shutters slam in from all sides, crushing down around the target in an instant!"
				HitSparkIcon='BLANK.dmi'
				HitSparkX=0
				HitSparkY=0
				Cooldown=30
				Instinct=2
				verb/Shutter_Doors()
					set category="Skills"
					usr.Activate(src)
