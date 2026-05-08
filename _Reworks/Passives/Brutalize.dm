/mob/proc/GetBrutalize()
    var/b = passive_handler.Get("Brutalize") //This stores stuff from sources of brutalize... yay.
    if(b) return clamp(b / 10, 0, 0.9)
    return 0
