/datum/element/traitor_desc
	element_flags = ELEMENT_DETACH | ELEMENT_BESPOKE
	id_arg_index = 2
	var/desc
	var/sabotage_target

/datum/element/traitor_desc/Attach(datum/target, _desc, _sabotage_target = null)
	. = ..()
	if(!isobj(target) || !_desc)
		return ELEMENT_INCOMPATIBLE
	src.desc = _desc
	src.sabotage_target = _sabotage_target
	RegisterSignal(target, COMSIG_PARENT_EXAMINE, .proc/on_examine)
	RegisterSignal(target, COMSIG_ATOM_ATTACK_HAND_SECONDARY, .proc/on_secondary)

/datum/element/traitor_desc/Detach(datum/target)
	. = ..()
	UnregisterSignal(target, list(
		COMSIG_PARENT_EXAMINE,
		COMSIG_ATOM_ATTACK_HAND_SECONDARY,
	))

/datum/element/traitor_desc/proc/on_examine(obj/target, mob/user, list/examine_list)
	SIGNAL_HANDLER
	if(is_traitor(user))
		examine_list += "<hr>"
		examine_list += span_rose(desc)

/datum/element/traitor_desc/proc/on_secondary(obj/target, mob/user, list/modifiers)
	SIGNAL_HANDLER

	if(!sabotage_target || !is_traitor(user) || !user.Adjacent(target))
		return COMPONENT_CANCEL_ATTACK_CHAIN

	var/action_message = null
	var/reward = 0

	switch(sabotage_target)
		if(SABOTAGE_ENGINE)
			if(GLOB.is_engine_sabotaged)
				to_chat(user, span_rose("Кто-то уже саботировал двигатель до этого. Лишнее внимание нам не нужно."))
				return COMPONENT_CANCEL_ATTACK_CHAIN

			GLOB.is_engine_sabotaged = TRUE
			action_message = "Меняю полярность ячеек."
			reward = 3
			for(var/obj/machinery/power/smes/S in GLOB.machines)
				S.RefreshParts()

		if(SABOTAGE_CARGO)
			if(GLOB.is_cargo_sabotaged)
				to_chat(user, span_rose("Кто-то уже саботировал снабжение до этого."))
				return COMPONENT_CANCEL_ATTACK_CHAIN

			GLOB.is_cargo_sabotaged = TRUE
			action_message = "Закорачиваю контакты, которые бережно были оставлены криворукими инженерами у всех на виду. Некоторая часть товаров в заказах будет заменена на случайные."
			reward = 1

		if(SABOTAGE_RESEARCH)
			if(GLOB.is_research_sabotaged)
				to_chat(user, span_rose("Кто-то уже саботировал научный отдел до этого."))
				return COMPONENT_CANCEL_ATTACK_CHAIN

			GLOB.is_research_sabotaged = TRUE
			action_message = "Ломаю лопасти вентиляторов. Посмотрим насколько системы с пассивной системой охлаждения эффективны."
			reward = 5

			for(var/obj/machinery/rnd/server/S in SSresearch.servers)
				S.current_temp = pick(228, 666)

	user.visible_message(span_danger("[user] ковыряется в [target].") ,\
		span_rose(action_message))

	var/datum/component/uplink/U = user.mind.find_syndicate_uplink()
	if(U)
		U.telecrystals += reward
