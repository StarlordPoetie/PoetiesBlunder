obj/Skills/Projectile/Getsuga_Tenshou
	name = "Getsuga Tenshou"
	Cooldown = 120

	StrRate = 1
	ForRate = 1
	DamageMult = 15
	AccMult = 1.2
	Distance = 20
	Homing = 1
	Instinct = 2
	Explode = 1

	IconLock = 'Small Getsuga.dmi'
	Variation = 0

	HeldSkill = TRUE
	ChargePeriod = 3
	SweetSpot = 1.5
	SweetSpotBenefit = 4.0
	ChargeOverlay='DarkShock.dmi'
	ChargeWaveIcon='KenShockwaveBloodlust.dmi'

	ActiveMessage = "releases a wave of Getsuga!"

	OnHeldRelease(mob/p, benefit, sweet_spot_hit)
		var/icon_used
		if(sweet_spot_hit)
			DamageMult *= benefit
			icon_used = 'Big Getsuga.dmi'
			LockX = -65
			LockY = -65
		else
			DamageMult *= benefit
			icon_used = 'Small Getsuga.dmi'
			LockX = -16
			LockY = -16
		p.Blast(src, p, 1, icon_used)

	verb/Getsuga_Tenshou()
		set category = "Skills"
		usr.BeginHeldSkill(src)
