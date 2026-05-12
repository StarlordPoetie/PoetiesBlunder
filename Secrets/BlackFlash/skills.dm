/obj/Skills/Buffs/SlotlessBuffs/Autonomous/QueueBuff
	Cursed_Energy_Maximum_Output
		BuffName = "Cursed Energy Maximum Output"
		Mastery=-1
		UnrestrictedBuff=1
		StrMult=1.20
		ForMult=1.20
		EndMult=1.20
		SpdMult=1.20
		DefMult=1.20
		MakesArmor=0
		TurfShift='WhiteTurfShift.dmi'
		TurfShiftInstant=1
		OffMult=1.20
		IconLock='CE Divergent Fist.dmi'
		TimerLimit=90
		passives = list("TechniqueMastery" = 5, "BuffMastery" = 2, "MovementMastery" = 5)
		DarkChange=1
		ActiveMessage="surges into Cursed Energy Maximum Output!"
		OffMessage="lets their Maximum Output fade."
		adjust(mob/p)
			ActiveMessage = "surges into Cursed Energy Maximum Output!"
		Trigger(mob/User, Override = 0)
			var/wasOn = User && User.BuffOn(src)
			var/result = ..()
			if(User)
				if(User.BuffOn(src))
					User.maxOutputActive = 1
					User.updateCursedEnergyMaximumOutputHUD()
				else if(wasOn)
					User.maxOutputActive = 0
					User.resetCursedEnergyMaximumOutputGauge()
			return result

	BlackFlash_Potential
		parent_type = /obj/Skills/Buffs/SlotlessBuffs/Autonomous/QueueBuff/Cursed_Energy_Maximum_Output
		BuffName = "Cursed Energy Maximum Output"

/obj/Skills/Buffs/SlotlessBuffs
	BlackFlash_SureStrike
		BuffName = "Sure-Strike Black Flash"
		Mastery=-1
		UnrestrictedBuff=1
		TimerLimit=5
		ActiveMessage="focuses and prepares to force a Black Flash!!!"
		passives = list("Sure-Strike Black Flash" = 1)
		Cooldown = 90
		verb/Black_Flash_SureStrike()
			set category="Skills"
			adjust(usr)
			src.Trigger(usr)

#define JJK_NARRATOR_COLOUR "#f7da1b"
/mob/proc/JJKNarrate(txt)
	OMessage(50, Msg = "<font color=[JJK_NARRATOR_COLOUR]>[txt]</font color>");

/mob/proc/BlackFlashGlazing(obj/Skills/Buffs/bfSkill)
	setBlackFlashFirstUse();
	setCursedEnergyBlackFlashFirstUse();
	JJKNarrate("It is not a technique you'd be able to see commonly. Not in these parts.");
	sleep(30)
	JJKNarrate("Most would simply use their energy to empower their whole body all at once- But this tends to cause a lag of sort, between your body and your energy.");
	sleep(30)
	JJKNarrate("This, inherently, lessen the impact your own energy has on your body. However...");
	sleep(30)
	JJKNarrate("If one was to infuse their energy, within one millionth of a second from a physical impact...");
	sleep(30)
	JJKNarrate("Space may distort for that moment- Energy sparking dark- And the destructive power of their attack raises to the power of two and a half.");
	sleep(30)
	JJKNarrate("A phenomenon known as a Black Flash. Following this, the user enters a state of awakening to their own energies-");
	sleep(30)
	JJKNarrate("Not too dissimilar to athletes entering 'The Zone', manipulating their power becomes as easy and natural as breathing.");
	sleep(30)
	JJKNarrate("In other words... For one minute and thirty seconds...");
	sleep(30)
	JJKNarrate("<b>[src] reaches the brink of Cursed Energy Maximum Output.</b>");


/mob/proc/
	getBlackFlashSecret()
		if(hasSecret("Black Flash")) return secretDatum;
		return 0;
	isBlackFlashFirstUse()
		var/SecretInformation/BlackFlash/bf = getBlackFlashSecret();
		if(bf) return bf.BlackFlashFirstTimeUse;
	setBlackFlashFirstUse()
		var/SecretInformation/BlackFlash/bf = getBlackFlashSecret();
		if(bf) bf.BlackFlashFirstTimeUse=0;
	getBlackFlashChance()
		var/SecretInformation/BlackFlash/bf = getBlackFlashSecret();
		var/force = bf.BlackFlashForcedChance;
		var/sureStrike = passive_handler.Get("Sure-Strike Black Flash")
		if(bf.BlackFlashChance < bf.BlackFlashBaseChance)
			bf.BlackFlashChance = bf.BlackFlashBaseChance
		if(sureStrike == 1) return 100;
		if(force) return force;

		else
			bf.BlackFlashChance += 5
			return clamp(bf.BlackFlashChance-5, bf.BlackFlashBaseChance, 90);