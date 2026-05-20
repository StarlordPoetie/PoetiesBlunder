mob
	var
	metahuman_origin = "Human"
	metahuman_power_origin = "Unknown Origin"
	metahuman_trait_points_remaining = 20
	list/metahuman_selected_traits = list()
	list/metahuman_selected_weaknesses = list()
	list/metahuman_physical_traits = list()

	proc/ChooseMetahumanOrigin()
		var/list/options = list("Human", "Alien", "Supernatural", "Monster")
		var/choice = input(src, "Choose your Metahuman origin.", "Metahuman Origin", metahuman_origin) in options
		if(choice)
			metahuman_origin = choice
		return metahuman_origin

	proc/ChooseMetahumanTraits(category = null)
		if(!metahuman_selected_traits)
			metahuman_selected_traits = list()
		if(!metahuman_selected_weaknesses)
			metahuman_selected_weaknesses = list()
		RecalcMetahumanTraitPoints()
		return

	proc/ChooseMetahumanPhysicalTraits()
		if(!metahuman_physical_traits)
			metahuman_physical_traits = list()
		return

	proc/RecalcMetahumanTraitPoints()
		metahuman_trait_points_remaining = 20
		return metahuman_trait_points_remaining

	proc/ApplyMetahumanTraits()
		if(!metahuman_selected_traits)
			metahuman_selected_traits = list()
		if(!metahuman_selected_weaknesses)
			metahuman_selected_weaknesses = list()
		if(!metahuman_physical_traits)
			metahuman_physical_traits = list()
		RecalcMetahumanTraitPoints()
		return
