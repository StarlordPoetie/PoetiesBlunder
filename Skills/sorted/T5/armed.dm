/obj/Skills/AutoHit
	Jest_of_the_Dead
		SkillCost=TIER_5_COST
		Copyable=6
		NeedsSword=1
		Area="Arc"
		StrOffense=1
		DamageMult=2.5
		LifeSteal=50
		WindUp=1
		WindupIcon='StormArmor.dmi'
		Rounds=10
		ChargeTech=1
		ChargeTime=1
		Knockback=1
		Cooldown=150
		Size=1
		Icon='reckless.dmi'
		IconX=-16
		IconY=-16
		WindupMessage="infuses their blade with the Ghosts of the Past..."
		ActiveMessage="carves through all in their path!"
		verb/Jest_of_the_Dead()
			set category="Skills"
			usr.Activate(src)
	Judgment_Cut_Jackpot
		AdaptRate=1
		DamageMult=16
		Area="Circle"
		Distance=12
		TurfStrike=1
		CanBeDodged=0
		CanBeBlocked=0
		GuardBreak=1
		Divide=1
		Slow=1
		WindUp=2
		IgnoreWindUpReduction=1
		WindupMessage="<b>sheathes their blade...</b>"
		ActiveMessage="yells: <font size = +1><b>JACKPOT!</b></font size>"
		Shockwaves=3
		Shockwave=4
		HitSparkIcon='Slash - Future.dmi'
		HitSparkX=-16
		HitSparkY=-16
		HitSparkTurns=1
		HitSparkSize=1
		HitSparkDispersion=1
		ComboMaster=1
obj/Skills/Queue
	Judgment_Cut_End
		SkillCost=TIER_5_COST
		Copyable=6
		HitMessage="warps through time and space!"
		name="Judgment Cut End"
		DamageMult=1
		AccuracyMult = 1.175
		Duration=15
		KBMult=0.01
		Finisher=1
		Dunker=4
		Warp=15
		Bolt=1
		Stunner=5
		NeedsSword=1
		EnergyCost=4
		FollowUp="/obj/Skills/AutoHit/Judgment_Cut_Jackpot"
		Cooldown=75
		verb/Judgment_Cut_End()
			set category="Skills"
			set name="Judgment Cut End"
			usr.SetQueue(src)