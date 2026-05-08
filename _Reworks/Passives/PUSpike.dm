/mob/proc/GetPUSpike()
    var/b = passive_handler.Get("PUSpike") //This stores stuff from sources of PUSpike... yay.
    b += GetMangLevel()*20
    if(Class=="Imaginary")
        if(ActiveBuff)
            b += 50
        if(SpecialBuff)
            b += 50
    if(b) return max(0, b / 100)
    return 0
