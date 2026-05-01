obj
	Skills
		Queue
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
