
globalTracker/var/list/IGNORE_POWER_CLAMP_PASSIVES = list("Wrathful", "LimitBroken", "Star Surge", "Heart of Darkness", "The Almighty", "The Flame of Youth","Shatter Fate","Determination(Black)", "Death-X-Evolution", "MaouKi","Undying Rage")


/mob/proc/ignoresPowerClamp(mob/defender)
    if(!defender) return
    if(defender.passive_handler && defender.passive_handler.Get("Justice"))
        return FALSE
    if(isRace(MAJIN))
        return TRUE
    if(istype(src, /mob/Player/AI) || istype(defender, /mob/Player/AI))
        return TRUE
    if(!src.passive_handler || !defender.passive_handler)
        return FALSE
    if(Secret == "Heavenly Restriction" && secretDatum?:hasImprovement("Power"))
        return TRUE
    for(var/passive in glob.IGNORE_POWER_CLAMP_PASSIVES)
        if(passive_handler|=passive)
            return TRUE
    if(passive_handler.Get("WrathFactor") && Health <= 50 && demonDevilTriggerSinMastery())
        return TRUE
    if(passive_handler.Get("Kaioken") && Health<=20||passive_handler.Get("Kaioken") && Kaioken>=5)
        return TRUE
    if(isRace(POPO))
        return TRUE
    if(isRace(DEMON))
        if(CheckSlotless("Corrupt Self"))
            return TRUE
        if(Health <= 15 + (AscensionsAcquired*5))
            if(CheckSlotless("True Form"))
                return TRUE
    var/godKi = !HasNullTarget() ? GetGodKi() : 0;
    var/defenderGodKi = !defender.HasNullTarget() ? defender.GetGodKi() : 0;
    if(!defenderGodKi)
        if(godKi)
            return TRUE
    else
        if(godKi)
            if((godKi > defenderGodKi) && godKi - defenderGodKi >= 0.5)
                return TRUE
    return FALSE
