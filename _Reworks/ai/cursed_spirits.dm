#define CURSED_SPIRIT_SIGHT_LEVEL 60

/mob/var/tmp/cursedSpiritDebugOverride = 0

/mob/proc/isCursedEnergyUser()
	return hasSecret("Cursed Energy")

/mob/proc/refreshCursedSpiritSight()
	if(isCursedEnergyUser() && see_invisible < CURSED_SPIRIT_SIGHT_LEVEL)
		see_invisible = CURSED_SPIRIT_SIGHT_LEVEL

/mob/proc/isCursedSpirit()
	return FALSE

/mob/proc/canInteractWithCursedSpirit(mob/spirit)
	if(!spirit || !spirit.isCursedSpirit())
		return TRUE
	if(Admin || cursedSpiritDebugOverride)
		return TRUE
	if(isCursedEnergyUser())
		refreshCursedSpiritSight()
		return TRUE
	return FALSE

/mob/Player/AI/CursedSpirit
	name = "Cursed Spirit"
	icon = 'Demon1.dmi'
	invisibility = CURSED_SPIRIT_SIGHT_LEVEL
	see_invisible = CURSED_SPIRIT_SIGHT_LEVEL
	density = 1
	var
		cursedSpirit = 1
		aggroRange = 12
		leashRange = 28
		aiTickDelay = 5
		adaptivePhase = "idle"
		mob/currentAITarget = null
		enrageThreshold = 35
		allowedTargetSecret = "Cursed Energy"
		spawn_loc = null
		ai_next_tick = 0
		threatDecayDelay = 300
		list/cursedThreat = list()

	New()
		..()
		spawn_loc = loc
		ai_hostility = 2
		hostile = 2
		ai_vision = aggroRange
		prioritize_players = 1
		ai_wander = 0
		ai_spammer = 1.25
		WoundIntent = 1
		adaptivePhase = "idle"
		if(!locate(/obj/Skills/Projectile/Blast, contents))
			AddSkill(new/obj/Skills/Projectile/Blast)
		if(!locate(/obj/Skills/AutoHit/ForcePalm, contents))
			AddSkill(new/obj/Skills/AutoHit/ForcePalm)
		for(var/mob/M in players)
			M.refreshCursedSpiritSight()

	Del()
		cursedThreat = null
		currentAITarget = null
		spawn_loc = null
		..()

	isCursedSpirit()
		return TRUE

	proc/isValidCursedTarget(mob/M, allowForced = 0)
		if(!M || M == src || !M.loc || !M.client)
			return FALSE
		if(M.KO || M.AdminOverwatchActive)
			return FALSE
		if(get_dist(src, M) > leashRange)
			return FALSE
		if(spawn_loc && get_dist(spawn_loc, M) > leashRange)
			return FALSE
		if(M.invisibility > see_invisible)
			return FALSE
		if(AllianceCheck(M))
			return FALSE
		if(allowForced && (M.Admin || M.cursedSpiritDebugOverride))
			return TRUE
		if(allowedTargetSecret && !M.hasSecret(allowedTargetSecret))
			return FALSE
		return TRUE

	proc/addThreat(mob/M, amount = 1)
		if(!M)
			return
		if(!cursedThreat)
			cursedThreat = list()
		cursedThreat[M] = max(cursedThreat[M], 0) + amount
		spawn(threatDecayDelay)
			if(src && cursedThreat && M in cursedThreat)
				cursedThreat[M] = max(0, cursedThreat[M] - amount)
				if(cursedThreat[M] <= 0)
					cursedThreat -= M

	proc/targetPriority(mob/M)
		if(!M)
			return -999999
		var/score = 0
		score += max(0, aggroRange - get_dist(src, M)) * 10
		if(cursedThreat && M in cursedThreat)
			score += cursedThreat[M] * 100
		if(M.Health < 100)
			score += (100 - M.Health)
		if(Target == M)
			score += 5
		return score

	proc/selectCursedTarget()
		var/mob/best = null
		var/bestScore = -999999
		for(var/mob/M in view(aggroRange, src))
			if(!isValidCursedTarget(M))
				continue
			var/score = targetPriority(M)
			if(!best || score > bestScore)
				best = M
				bestScore = score
		return best

	proc/setCursedTarget(mob/M)
		if(!isValidCursedTarget(M, 1))
			RemoveTarget()
			currentAITarget = null
			return FALSE
		SetTarget(M)
		currentAITarget = M
		last_activity = world.time
		return TRUE

	proc/updateAdaptivePhase()
		if(Health <= enrageThreshold)
			if(adaptivePhase != "enraged")
				adaptivePhase = "enraged"
				ai_spammer = max(ai_spammer, 1.75)
				AngerMax = max(AngerMax, 1.5)
				passive_handler.Increase("Godspeed", 1)
			return
		if(Health <= 15 && Target)
			adaptivePhase = "recovering"
		else if(Target && get_dist(src, Target) <= 10)
			adaptivePhase = "fighting"
		else if(Target)
			adaptivePhase = "hunting"
		else
			adaptivePhase = "idle"

	proc/repositionIfNeeded()
		if(adaptivePhase != "recovering" || !Target)
			return FALSE
		if(world.time >= next_move)
			step_away(src, Target, 6, 32 * (5 / (AI_SPEED_TOTAL * AI_MOVE_SPEED)))
			dir = get_dir(Target, src)
			next_move = world.time + 2
			return TRUE
		return FALSE

	proc/processCursedSpiritAI()
		if(KO || !loc)
			return
		if(isCrowdControlled())
			return
		if(Target && (!ismob(Target) || !isValidCursedTarget(Target, 1)))
			RemoveTarget()
			currentAITarget = null
		if(!Target)
			var/mob/newTarget = selectCursedTarget()
			if(newTarget)
				setCursedTarget(newTarget)
		updateAdaptivePhase()
		if(!Target)
			ai_state = "Idle"
			if(spawn_loc && loc != spawn_loc && world.time >= next_move)
				step_to(src, spawn_loc, 0, 32 * (5 / (AI_SPEED_TOTAL * AI_MOVE_SPEED)))
				next_move = world.time + 3
			return
		currentAITarget = Target
		if(repositionIfNeeded())
			return
		ai_state = "Chase"
		Chase()

	AiBehavior()
		if(world.time < ai_next_tick)
			return
		ai_next_tick = world.time + aiTickDelay
		processCursedSpiritAI()

	FindTarget()
		var/mob/M = selectCursedTarget()
		if(M)
			setCursedTarget(M)
			return TRUE
		return FALSE

	FindTarget1()
		return FindTarget()

	HitCheck()
		var/list/to_hit = list()
		for(var/mob/M in oview(1, src))
			if(isValidCursedTarget(M, 1))
				to_hit += M
		return to_hit

	Chase()
		if(!Target || !isValidCursedTarget(Target, 1))
			RemoveTarget()
			currentAITarget = null
			return
		..()

	BasicTrainingDummy
		name = "Test Cursed Spirit"
		icon = 'Demon1.dmi'
		aggroRange = 14
		leashRange = 32
		aiTickDelay = 4
		enrageThreshold = 40
		Potential = 50
		StrMod = 3
		ForMod = 3
		EndMod = 3
		SpdMod = 2
		OffMod = 2
		DefMod = 2
		RecovMod = 2

/mob/Admin3/verb/Spawn_Test_Cursed_Spirit()
	set category = "Admin"
	set name = "Spawn Test Cursed Spirit"
	for(var/mob/Player/AI/CursedSpirit/BasicTrainingDummy/S in oview(10, src))
		if(S.ckey == null)
			src << "A test Cursed Spirit is already nearby: [S]. Remove it before spawning another."
			return
	var/turf/T = get_step(src, dir)
	if(!T || T.density)
		T = loc
	var/mob/Player/AI/CursedSpirit/BasicTrainingDummy/S = new()
	S.loc = T
	S.name = "Admin Test Cursed Spirit ([src.key])"
	S.spawn_loc = S.loc
	src << "Spawned [S] at [S.x], [S.y], [S.z]. Only Cursed Energy users should see or fight it."
