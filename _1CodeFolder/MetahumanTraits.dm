#define METAHUMAN_TRAIT_POINTS 20

var/global/list/metahuman_origins = list("Human","Alien","Supernatural","Monster")

/datum/metahuman_trait
	var/id
	var/name
	var/category = "Power"
	var/description = ""
	var/effects = ""
	var/cost = 0
	var/list/passives = list()
	var/list/origin_requirements = list()
	var/list/conflicts = list()
	New(_id,_name,_cost,_category,_description,_effects,list/_passives = null,list/_origin_requirements = null,list/_conflicts = null)
		id = _id
		name = _name
		cost = _cost
		category = _category
		description = _description
		effects = _effects
		passives = _passives ? _passives.Copy() : list()
		origin_requirements = _origin_requirements ? _origin_requirements.Copy() : list()
		conflicts = _conflicts ? _conflicts.Copy() : list()

var/global/list/metahuman_traits = list()

/proc/BuildMetahumanTraitDatabase()
	if(length(metahuman_traits)) return
	metahuman_traits["super_strength"] = new /datum/metahuman_trait("super_strength","Super Strength",6,"Power","Enhanced muscular output for overwhelming close combat.","Increases melee impact and carry-through force.",list("HardStyle"=1,"MeleePush"=1),null,list("accelerated_reflexes"))
	metahuman_traits["accelerated_reflexes"] = new /datum/metahuman_trait("accelerated_reflexes","Accelerated Reflexes",6,"Power","Hyper-fast response timing and battle awareness.","Improves reaction and evasion passives.",list("Godspeed"=1,"Instinct"=1),null,list("super_strength"))
	metahuman_traits["energy_conduit"] = new /datum/metahuman_trait("energy_conduit","Energy Conduit",5,"Power","Body channels energy efficiently for sustained output.","Improves recovery and ranged force handling.",list("Flow"=1,"ManaCapMult"=0.1))
	metahuman_traits["regenerative_body"] = new /datum/metahuman_trait("regenerative_body","Regenerative Body",7,"Power","Biological or mystic regenerative adaptation.","Adds regeneration-oriented passive bonuses.",list("Regeneration"=1),list("Monster","Supernatural"))
	metahuman_traits["monstrous_durability"] = new /datum/metahuman_trait("monstrous_durability","Monstrous Durability",7,"Power","Dense structure and abnormal resilience.","Adds toughness and injury resistance.",list("Juggernaut"=1,"DebuffImmune"=0.1),list("Monster","Alien"))
	metahuman_traits["fragile_frame"] = new /datum/metahuman_trait("fragile_frame","Fragile Frame",-4,"Weakness","Your body cannot absorb punishment well.","Reduced endurance and defensive staying power.",list("DebuffVulnerable"=0.1))
	metahuman_traits["poor_control"] = new /datum/metahuman_trait("poor_control","Poor Control",-5,"Weakness","Your power surges unpredictably and wastes output.","Higher exertion inefficiency and unstable throughput.",list("ManaLeak"=1))
	metahuman_traits["unstable_power"] = new /datum/metahuman_trait("unstable_power","Unstable Power",-6,"Weakness","Power spikes high but destabilizes combat pacing.","Burst-oriented strength with consistency drawbacks.",list("Desperation"=0.1,"CalmAnger"=0.2))

/mob/var/metahuman_origin = "Human"
/mob/var/list/metahuman_positive_traits = list()
/mob/var/list/metahuman_weakness_traits = list()
/mob/var/list/metahuman_physical_traits = list()
/mob/var/tmp/metahuman_trait_points_remaining = METAHUMAN_TRAIT_POINTS

/mob/proc/MetahumanTraitSpent()
	var/spent = 0
	for(var/id in metahuman_positive_traits)
		var/datum/metahuman_trait/T = metahuman_traits[id]
		if(T) spent += T.cost
	for(var/id in metahuman_weakness_traits)
		var/datum/metahuman_trait/T2 = metahuman_traits[id]
		if(T2) spent += T2.cost
	return spent

/mob/proc/RecalcMetahumanTraitPoints()
	metahuman_trait_points_remaining = METAHUMAN_TRAIT_POINTS - MetahumanTraitSpent()

/mob/proc/ApplyMetahumanTraits()
	if(!passive_handler) return
	for(var/id in metahuman_positive_traits + metahuman_weakness_traits)
		var/datum/metahuman_trait/T = metahuman_traits[id]
		if(T && length(T.passives))
			passive_handler.Increase(T.passives)

/mob/proc/ChooseMetahumanOrigin()
	metahuman_origin = input(src, "Choose your metahuman origin.", "Metahuman Origin") in metahuman_origins
	if(!metahuman_origin) metahuman_origin = "Human"

/mob/proc/ChooseMetahumanTraits(category = "Power")
	BuildMetahumanTraitDatabase()
	var/choosing = TRUE
	while(choosing)
		RecalcMetahumanTraitPoints()
		var/list/options = list("Done")
		for(var/id in metahuman_traits)
			var/datum/metahuman_trait/T = metahuman_traits[id]
			if(!T || T.category != category) continue
			if(length(T.origin_requirements) && !(metahuman_origin in T.origin_requirements)) continue
			options += "[T.name] ([T.cost>=0?"Cost":"Refund"] [abs(T.cost)])"
		var/ch = input(src, "[category] traits. Remaining points: [metahuman_trait_points_remaining]", "Trait Selection") in options
		if(!ch || ch == "Done")
			choosing = FALSE
			continue
		for(var/id in metahuman_traits)
			var/datum/metahuman_trait/T = metahuman_traits[id]
			if(findtext(ch, T.name) == 1)
				var/list/bucket = (category == "Weakness") ? metahuman_weakness_traits : metahuman_positive_traits
				if(id in bucket)
					bucket -= id
					break
				var/has_conflict = FALSE
				for(var/c in T.conflicts)
					if(c in metahuman_positive_traits || c in metahuman_weakness_traits)
						has_conflict = TRUE
				if(has_conflict)
					src << "That trait conflicts with a selected trait."
					break
				if(category != "Weakness" && (metahuman_trait_points_remaining - T.cost) < 0)
					src << "Not enough trait points."
					break
				bucket += id
				break

/mob/proc/ChooseMetahumanPhysicalTraits()
	var/list/physical_options = list("Horns","Tail","Claws","Fangs","Wings","Animal ears","Scales","Extra eyes","Aura mutation","Monstrous markings")
	metahuman_physical_traits = list()
	for(var/opt in physical_options)
		if(alert(src, "Add [opt]?", "Physical Traits", "Yes", "No") == "Yes")
			metahuman_physical_traits += opt
