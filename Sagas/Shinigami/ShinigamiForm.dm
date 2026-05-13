/obj/Skills/Buffs/SlotlessBuffs/Shinigami_Form
	name = "Shinigami Form"
	Slotless = 1
	FlashChange = 1

	adjust(mob/p)
		if(altered) return
		var/SL = p.SagaLevel
		passives = list(
			"MartialMagic"   = 1,
			"ManaGeneration" = 2 * SL,
			"SpiritSword"    = 0.5 * SL,
			"SpiritFlow"     = 1 * SL,
			"SpiritPower"    = 0.15 * SL,
			"HolyMod"        = 2,
			"EvilResist"     = 2
		)

	proc/applyForm(mob/p)
		if(p.equippedSword)
			p.equippedSword.UnEquip(p)
		if(p.equippedArmor)
			p.equippedArmor.UnEquip(p)
		for(var/obj/Items/i in p)
			if(i.IsZanpakuto)
				i.Equip(p)
				break
		for(var/obj/Items/i in p)
			if(i.IsShihakusho)
				i.Equip(p)
				break
		p.InShinigamiForm = TRUE

	proc/revertForm(mob/p)
		for(var/obj/Items/i in p)
			if(i.IsZanpakuto && i.suffix)
				i.UnEquip(p)
		for(var/obj/Items/i in p)
			if(i.IsShihakusho && i.suffix)
				i.UnEquip(p)
		revertZanpakutoIcon(p)
		p.InShinigamiForm = FALSE

	proc/applyShikaiIcon(mob/user)
		if(!user.ShikaiIcon) return
		for(var/obj/Items/i in user)
			if(i.IsZanpakuto && i.suffix)
				user.AppearanceOff()
				i.icon = user.ShikaiIcon
				i.pixel_x = user.ShikaiIconX
				i.pixel_y = user.ShikaiIconY
				user.AppearanceOn()
				break

	proc/applyBankaiIcon(mob/user)
		if(!user.BankaiIcon) return
		for(var/obj/Items/i in user)
			if(i.IsZanpakuto && i.suffix)
				user.AppearanceOff()
				i.icon = user.BankaiIcon
				i.pixel_x = user.BankaiIconX
				i.pixel_y = user.BankaiIconY
				user.AppearanceOn()
				break

	proc/revertZanpakutoIcon(mob/user)
		for(var/obj/Items/i in user)
			if(i.IsZanpakuto && i.suffix)
				user.AppearanceOff()
				i.icon = 'Goemon Katana Unsheathed.dmi'
				i.pixel_x = -16
				i.pixel_y = -16
				user.AppearanceOn()
				break

	verb/Shinigami_Form()
		set name = "Shinigami Form"
		set category = "Skills"
		if(!src.SlotlessOn)
			var/obj/Skills/Buffs/SlotlessBuffs/Mugetsu_Aftermath/MA = locate(/obj/Skills/Buffs/SlotlessBuffs/Mugetsu_Aftermath, usr)
			if(MA && MA.SlotlessOn)
				usr << "You have lost your Shinigami powers. You cannot enter Shinigami Form until you transcend."
				return
			var/hasZ = FALSE
			var/hasSH = FALSE
			for(var/obj/Items/i in usr)
				if(i.IsZanpakuto) hasZ = TRUE
				if(i.IsShihakusho) hasSH = TRUE
			if(!hasZ || !hasSH)
				usr << "You need your Zanpakutō and Shihakushō to enter Shinigami Form."
				return
			adjust(usr)
			src.Trigger(usr)
			applyForm(usr)
		else
			if(usr.InShikai() || usr.InBankai())
				usr << "You cannot exit Shinigami Form while in Shikai or Bankai!"
				return
			revertForm(usr)
			src.Trigger(usr)

	verb/Change_Shikai_Appearance()
		set name = "Change Shikai Appearance"
		set category = "Skills"
		var/icon/newIcon = input(usr, "Set Zanpakutō Shikai icon to what?") as icon|null
		if(isnull(newIcon)) return
		var/newX = input(usr, "Pixel X offset?") as num
		var/newY = input(usr, "Pixel Y offset?") as num
		usr.ShikaiIcon = newIcon
		usr.ShikaiIconX = newX
		usr.ShikaiIconY = newY
		if(usr.InShikai())
			applyShikaiIcon(usr)

	verb/Change_Bankai_Appearance()
		set name = "Change Bankai Appearance"
		set category = "Skills"
		var/icon/newIcon = input(usr, "Set Zanpakutō Bankai icon to what?") as icon|null
		if(isnull(newIcon)) return
		var/newX = input(usr, "Pixel X offset?") as num
		var/newY = input(usr, "Pixel Y offset?") as num
		usr.BankaiIcon = newIcon
		usr.BankaiIconX = newX
		usr.BankaiIconY = newY
		if(usr.InBankai())
			applyBankaiIcon(usr)
