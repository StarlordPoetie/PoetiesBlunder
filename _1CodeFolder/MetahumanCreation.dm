// Minimal compile-safe metahuman creation scaffolding.
// This file intentionally provides safe defaults and placeholder behavior
// without redesigning existing creation/stat/combat systems.

var/basehtml = ""

var/global/list/metahuman_origin_options = list("Human", "Alien", "Supernatural", "Monster")

/mob/var
	metahuman_origin = "Human"
	metahuman_power_origin = "Unknown Origin"
	metahuman_trait_points_remaining = 20
	list/metahuman_selected_traits = list()
	list/metahuman_selected_weaknesses = list()
	list/metahuman_physical_traits = list()

/mob/proc/ChooseMetahumanOrigin()
	if(!metahuman_origin_options || !length(metahuman_origin_options))
		metahuman_origin_options = list("Human", "Alien", "Supernatural", "Monster")
	var/choice = input(src, "Choose your origin.", "Metahuman Origin") as null|anything in metahuman_origin_options
	if(choice)
		metahuman_origin = "[choice]"
	else if(!metahuman_origin)
		metahuman_origin = "Human"
	if(!metahuman_power_origin)
		metahuman_power_origin = "Unknown Origin"
	return metahuman_origin

/mob/proc/ChooseMetahumanTraits(category = "Power")
	if(!islist(metahuman_selected_traits))
		metahuman_selected_traits = list()
	if(!islist(metahuman_selected_weaknesses))
		metahuman_selected_weaknesses = list()
	RecalcMetahumanTraitPoints()
	return

/mob/proc/ChooseMetahumanPhysicalTraits()
	if(!islist(metahuman_physical_traits))
		metahuman_physical_traits = list()
	return

/mob/proc/RecalcMetahumanTraitPoints()
	if(!islist(metahuman_selected_traits))
		metahuman_selected_traits = list()
	if(!islist(metahuman_selected_weaknesses))
		metahuman_selected_weaknesses = list()
	// Placeholder math: start at 20 and only use list lengths until full trait definitions are wired.
	metahuman_trait_points_remaining = 20 - length(metahuman_selected_traits) + length(metahuman_selected_weaknesses)
	return metahuman_trait_points_remaining

/mob/proc/ApplyMetahumanTraits()
	// Placeholder: safely no-op unless future trait definitions are implemented.
	if(!islist(metahuman_selected_traits))
		metahuman_selected_traits = list()
	if(!islist(metahuman_selected_weaknesses))
		metahuman_selected_weaknesses = list()
	return
