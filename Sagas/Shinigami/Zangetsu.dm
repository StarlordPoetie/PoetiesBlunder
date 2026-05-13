/obj/Skills/Buffs/SlotlessBuffs/Mugetsu_Aftermath
	name = "Lost Shinigami Powers"
	Slotless = 1

	adjust(mob/p)
		if(altered) return
		passives = list(
			"ManaLeak"   = 5,
			"EnergyLeak" = 5
		)
		StrMult = 0.7
		EndMult = 0.7
		ForMult = 0.7
		SpdMult = 0.5
		OffMult = 0.5
		DefMult = 0.5

/obj/Skills/Projectile/True_Getsuga_Tenshou
	name = "True Getsuga Tenshou"
	Cooldown = 180
	NeedsSword = 1
	StrRate = 1
	ForRate = 1
	DamageMult = 35
	AccMult = 1.3
	Distance = 20
	Homing = 1
	Instinct = 2
	Explode = 1
	BypassTempHP = 1
	SkillDeicide = 20

	IconLock = 'Big Getsuga Shikai.dmi'
	LockX = -65
	LockY = -65
	Variation = 0

	ActiveMessage = "releases the true essence of Getsuga!"

	proc/FireTrue(mob/p)
		if(!p || !p.loc) return
		if(!p.Target || p.Target == p)
			p << "You need a target to use True Getsuga Tenshou."
			return
		if(Using || cooldown_remaining) return

		src.Cooldown(1, null, p)
		OMsg(p, "<b><font color='#1a1a2e'>[p] [ActiveMessage]</font></b>")
		p.Blast(src, p, 1, 'Big Getsuga Shikai.dmi')

	verb/True_Getsuga_Tenshou()
		set name = "True Getsuga Tenshou"
		set category = "Skills"
		if(!usr.CheckSlotless("Tensa Zangetsu"))
			usr << "True Getsuga Tenshou can only be used in Bankai."
			return
		FireTrue(usr)

/obj/Skills/Buffs/SlotlessBuffs/Zangetsu
	name = "Zangetsu"
	Slotless = 1
	ManaThreshold = 2
	IsShikaiForm = 1

	adjust(mob/p)
		if(altered) return
		var/SL = p.SagaLevel
		passives = list(
			"Zornhau"        = 1 + SL,
			"Half-Sword"     = 1 + SL,
			"Extend"         = 0.5 * SL,
			"GiantSwings"    = 1,
			"SweepingStrike" = 1 + (0.25 * SL),
			"PureDamage"     = 1 + SL
		)
		if(SL < 3)
			passives["ManaLeak"] = 2
		StrMult = 1.1 + (0.1 * SL)
		ForMult = 1.1 + (0.1 * SL)
		OffMult = 1.1 + (0.1 * SL)

	Trigger(mob/user)
		var/wasOn = src.SlotlessOn
		..()
		if(wasOn && !src.SlotlessOn)
			var/obj/Skills/Buffs/SlotlessBuffs/Shinigami_Form/sf = user.FindSkill(/obj/Skills/Buffs/SlotlessBuffs/Shinigami_Form)
			if(sf) sf.revertZanpakutoIcon(user)

	verb/Shikai()
		set name = "Shikai"
		set category = "Skills"
		if(!src.SlotlessOn)
			if(!usr.InShinigamiForm)
				usr << "You must be in Shinigami Form to use Shikai."
				return
			if(usr.InBankai())
				usr << "You cannot use Shikai while in Bankai."
				return
			var/hasZanpakuto = FALSE
			for(var/obj/Items/i in usr)
				if(i.IsZanpakuto && i.suffix)
					hasZanpakuto = TRUE
					break
			if(!hasZanpakuto)
				usr << "You must have your Zanpakutō equipped to use Shikai."
				return
			adjust(usr)
			OMsg(usr, "<b>[usr] calls out, \"[usr.ShikaiCall], [usr.AsauchiName]!\"</b>")
			src.Trigger(usr)
			var/obj/Skills/Buffs/SlotlessBuffs/Shinigami_Form/sf = usr.FindSkill(/obj/Skills/Buffs/SlotlessBuffs/Shinigami_Form)
			if(sf) sf.applyShikaiIcon(usr)
			if(!locate(/obj/Skills/Projectile/Getsuga_Tenshou, usr))
				usr.AddSkill(new/obj/Skills/Projectile/Getsuga_Tenshou)
		else
			src.Trigger(usr)

/obj/Skills/Buffs/SlotlessBuffs/Tensa_Zangetsu
	name = "Tensa Zangetsu"
	Slotless = 1
	ManaThreshold = 2
	IsBankaiForm = 1

	adjust(mob/p)
		if(altered) return
		var/SL = p.SagaLevel
		passives = list(
			"Flicker"         = 1 + SL,
			"BlurringStrikes" = 1 + SL,
			"Afterimages"     = 1,
			"Godspeed"        = 1 + SL,
			"Warping"         = 0.5 + (SL/2),
			"HybridStrike"    = 0.5 + (SL/2),
			"EmptyFlashStep"  = 1 + SL,
			"PureDamage"      = 1 + SL
		)
		if(SL < 5)
			passives["ManaLeak"] = 4
		StrMult = 1.3 + (0.1 * SL)
		ForMult = 1.3 + (0.1 * SL)
		SpdMult = 1.3 + (0.1 * SL)

	Trigger(mob/user)
		var/wasOn = src.SlotlessOn
		..()
		if(wasOn && !src.SlotlessOn)
			var/obj/Skills/Buffs/SlotlessBuffs/Shinigami_Form/sf = user.FindSkill(/obj/Skills/Buffs/SlotlessBuffs/Shinigami_Form)
			if(sf) sf.revertZanpakutoIcon(user)
			if(istype(user.SpecialBuff, /obj/Skills/Buffs/SpecialBuffs/Sword/Getsuga_Tenshou_Clad))
				user.SpecialBuff.Trigger(user)
			if(istype(user.SpecialBuff, /obj/Skills/Buffs/SpecialBuffs/Sword/Final_Getsuga_Tenshou))
				user.SpecialBuff.Trigger(user)

	verb/Bankai()
		set name = "Bankai"
		set category = "Skills"
		if(!src.SlotlessOn)
			if(!usr.InShinigamiForm)
				usr << "You must be in Shinigami Form to use Bankai."
				return
			if(usr.InShikai())
				usr << "You must end Shikai before entering Bankai."
				return
			var/hasZanpakuto = FALSE
			for(var/obj/Items/i in usr)
				if(i.IsZanpakuto && i.suffix)
					hasZanpakuto = TRUE
					break
			if(!hasZanpakuto)
				usr << "You must have your Zanpakutō equipped to use Bankai."
				return
			adjust(usr)
			OMsg(usr, "<b>[usr] calls out, \"Bankai... [usr.BankaiPrefix] [usr.AsauchiName]!\"</b>")
			src.Trigger(usr)
			var/obj/Skills/Buffs/SlotlessBuffs/Shinigami_Form/sf = usr.FindSkill(/obj/Skills/Buffs/SlotlessBuffs/Shinigami_Form)
			if(sf) sf.applyBankaiIcon(usr)
		else
			src.Trigger(usr)
