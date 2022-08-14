/**
 * # Poison Hostile Simplemob
 *
 * A subtype of the hostile simplemob which injects reagents into its target on attack, assuming the target accepts reagents.
 */
/mob/living/simple_animal/hostile/poison
	///How much of a reagent the mob injects on attack
	var/poison_per_bite = 5
	///What reagent the mob injects targets with
	var/poison_type = /datum/reagent/toxin

/mob/living/simple_animal/hostile/poison/AttackingTarget()
	. = ..()
	if(.)
		inject_poison(target)

/**
 * Injects poison into a given target.
 *
 * Checks if a given target accepts reagents, and then injects a given reagent into them if so.
 * Arguments:
 * * living_target - The targeted mob
 */
/mob/living/simple_animal/hostile/poison/proc/inject_poison(mob/living/living_target)
	if(poison_per_bite != 0 && living_target?.reagents)
		living_target.reagents.add_reagent(poison_type, poison_per_bite)

/**
 * # Giant Spider
 *
 * A versatile mob which can occur from a variety of sources.
 *
 * A mob which can be created by botany or xenobiology.  The basic type is the guard, which is slower but sturdy and outputs good damage.
 * All spiders can produce webbing.  Currently does not inject toxin into its target.
 */
/mob/living/simple_animal/hostile/poison/giant_spider
	name = "огромный паук"
	desc = "Черный и пушистый, с огромными хелицерами и красными светящимися глазами, что то в нем заставляет испытывать первобытный страх."
	icon_state = "guard"
	icon_living = "guard"
	icon_dead = "guard_dead"
	mob_biotypes = MOB_ORGANIC|MOB_BUG
	speak_emote = list("трепещет")
	emote_hear = list("трепещет")
	speak_chance = 5
	speed = 0
	turns_per_move = 5
	see_in_dark = 4
	butcher_results = list(/obj/item/food/meat/slab/spider = 2, /obj/item/food/spiderleg = 8)
	response_help_continuous = "гладит"
	response_help_simple = "гладит"
	response_disarm_continuous = "аккуратно отталкивает"
	response_disarm_simple = "аккуратно отталкивает"
	initial_language_holder = /datum/language_holder/spider
	maxHealth = 80
	health = 80
	damage_coeff = list(BRUTE = 1, BURN = 1, TOX = 1, CLONE = 1, STAMINA = 1, OXY = 1)
	unsuitable_cold_damage = 10
	unsuitable_heat_damage = 10
	obj_damage = 30
	melee_damage_lower = 20
	melee_damage_upper = 25
	faction = list("spiders")
	pass_flags = PASSTABLE
	move_to_delay = 6
	attack_verb_continuous = "кусает"
	attack_verb_simple = "кусает"
	attack_sound = 'sound/weapons/bite.ogg'
	attack_vis_effect = ATTACK_EFFECT_BITE
	unique_name = 1
	gold_core_spawnable = HOSTILE_SPAWN
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
	footstep_type = FOOTSTEP_MOB_CLAW
	poison_per_bite = 0
	///Whether or not the spider is in the middle of an action.
	var/is_busy = FALSE
	///How quickly the spider can place down webbing.  One is base speed, larger numbers are slower.
	var/web_speed = 1
	///The web laying ability
	var/datum/action/innate/spider/lay_web/lay_web
	///The message that the mother spider left for this spider when the egg was layed.
	var/directive = ""
	discovery_points = 1000

/mob/living/simple_animal/hostile/poison/giant_spider/Initialize(mapload)
	. = ..()
	lay_web = new
	lay_web.Grant(src)
	if(poison_per_bite)
		AddElement(/datum/element/venomous, poison_type, poison_per_bite)
	AddElement(/datum/element/nerfed_pulling, GLOB.typecache_general_bad_things_to_easily_move)
	AddElement(/datum/element/prevent_attacking_of_types, GLOB.typecache_general_bad_hostile_attack_targets, "Мерзость! Оно плохо пахнет! Нехочу это есть или трогать!")

/mob/living/simple_animal/hostile/poison/giant_spider/Login()
	. = ..()
	if(!. || !client)
		return FALSE
	if(directive)
		to_chat(src, span_spider("Королева отдала приказ! Его необходимо выполнить любой ценой!"))
		to_chat(src, span_spider("<b>[directive]</b>"))
		if(mind)
			mind.store_memory(span_spider("<b>[directive]</b>"))
	GLOB.spidermobs[src] = TRUE

/mob/living/simple_animal/hostile/poison/giant_spider/Destroy()
	GLOB.spidermobs -= src
	return ..()

/mob/living/simple_animal/hostile/poison/giant_spider/handle_temperature_damage()
	if(bodytemperature < minbodytemp)
		adjustBruteLoss(20)
		throw_alert("temp", /atom/movable/screen/alert/cold, 3)
	else if(bodytemperature > maxbodytemp)
		adjustBruteLoss(20)
		throw_alert("temp", /atom/movable/screen/alert/hot, 3)
	else
		clear_alert("temp")

/**
 * # Spider Hunter
 *
 * A subtype of the giant spider with purple eyes and toxin injection.
 *
 * A subtype of the giant spider which is faster, has toxin injection, but less health.  This spider is only slightly slower than a human.
 */
/mob/living/simple_animal/hostile/poison/giant_spider/hunter
	name = "паук охотник"
	desc = "Самый распространный вид космичесских пауков, это быстрый и весьма ядовитый паразит с фиолетовыми глазами."
	icon_state = "hunter"
	icon_living = "hunter"
	icon_dead = "hunter_dead"
	maxHealth = 50
	health = 50
	melee_damage_lower = 15
	melee_damage_upper = 20
	poison_per_bite = 5
	move_to_delay = 5
	speed = -0.1

/**
 * # Spider Nurse
 *
 * A subtype of the giant spider with green eyes that specializes in support.
 *
 * A subtype of the giant spider which specializes in support skills.  Nurses can place down webbing in a quarter of the time
 * that other species can and can wrap other spiders' wounds, healing them.  Note that it cannot heal itself.
 */
/mob/living/simple_animal/hostile/poison/giant_spider/nurse
	name = "паучья фрейлина"
	desc = "Этих экземпляров редко можно увидеть вне гнезда, а в бою они обычно держатся позади, однако убивать их нужно в первую очередь, ведь именно они откладывают яйца и выхаживают раненых бойцов."
	icon_state = "nurse"
	icon_living = "nurse"
	icon_dead = "nurse_dead"
	gender = FEMALE
	butcher_results = list(/obj/item/food/meat/slab/spider = 2, /obj/item/food/spiderleg = 8, /obj/item/food/spidereggs = 4)
	maxHealth = 40
	health = 40
	melee_damage_lower = 5
	melee_damage_upper = 10
	poison_per_bite = 3
	web_speed = 0.25
	///The health HUD applied to the mob.
	var/health_hud = DATA_HUD_MEDICAL_ADVANCED

/mob/living/simple_animal/hostile/poison/giant_spider/nurse/Initialize(mapload)
	. = ..()
	var/datum/atom_hud/datahud = GLOB.huds[health_hud]
	datahud.show_to(src)

/mob/living/simple_animal/hostile/poison/giant_spider/nurse/AttackingTarget()
	if(is_busy)
		return
	if(!istype(target, /mob/living/simple_animal/hostile/poison/giant_spider))
		return ..()
	var/mob/living/simple_animal/hostile/poison/giant_spider/hurt_spider = target
	if(hurt_spider == src)
		to_chat(src, span_warning("Не получается извернуться и дотянутся до своих собственных ран."))
		return
	if(hurt_spider.health >= hurt_spider.maxHealth)
		to_chat(src, span_warning("Этот собрат цел."))
		return
	visible_message(span_notice("[src] начинает залатывать раны [hurt_spider].") ,span_notice("Начинаю залатывать раны [hurt_spider]."))
	is_busy = TRUE
	if(do_after(src, 20, target = hurt_spider))
		hurt_spider.heal_overall_damage(20, 20)
		new /obj/effect/temp_visual/heal(get_turf(hurt_spider), "#80F5FF")
		visible_message(span_notice("[src] залатала раны [hurt_spider].") ,span_notice("Залатываю раны [hurt_spider]."))
	is_busy = FALSE

/**
 * # Tarantula
 *
 * The tank of spider subtypes.  Is incredibly slow when not on webbing, but has a lunge and the highest health and damage of any spider type.
 *
 * A subtype of the giant spider which specializes in pure strength and staying power.  Is slowed down greatly when not on webbing, but can lunge
 * to throw off attackers and possibly to stun them, allowing the tarantula to net an easy kill.
 */
/mob/living/simple_animal/hostile/poison/giant_spider/tarantula
	name = "тарантул"
	desc = "Огромный даже для космического паука, невероятно сильный и живучий. Чаще всего их можно обнаружить на страже крупных гнезд, за их границами они чувствуют себя некомфортно."
	icon_state = "tarantula"
	icon_living = "tarantula"
	icon_dead = "tarantula_dead"
	maxHealth = 300 // woah nelly
	health = 300
	melee_damage_lower = 35
	melee_damage_upper = 40
	obj_damage = 100
	damage_coeff = list(BRUTE = 1, BURN = 1, TOX = 1, CLONE = 1, STAMINA = 0, OXY = 1)
	poison_per_bite = 0
	move_to_delay = 8
	speed = 1
	status_flags = NONE
	mob_size = MOB_SIZE_LARGE
	gold_core_spawnable = NO_SPAWN
	///Whether or not the tarantula is currently walking on webbing.
	var/silk_walking = TRUE
	/// Charging ability
	var/datum/action/cooldown/mob_cooldown/charge/basic_charge/charge

/mob/living/simple_animal/hostile/poison/giant_spider/tarantula/Initialize(mapload)
	. = ..()
	charge = new /datum/action/cooldown/mob_cooldown/charge/basic_charge()
	charge.Grant(src)

/mob/living/simple_animal/hostile/poison/giant_spider/tarantula/Destroy()
	QDEL_NULL(charge)
	return ..()

/mob/living/simple_animal/hostile/poison/giant_spider/tarantula/OpenFire()
	if(client)
		return
	charge.Trigger(target = target)

/mob/living/simple_animal/hostile/poison/giant_spider/tarantula/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change = TRUE)
	. = ..()
	var/obj/structure/spider/stickyweb/web = locate() in loc
	if(web && !silk_walking)
		remove_movespeed_modifier(/datum/movespeed_modifier/tarantula_web)
		silk_walking = TRUE
	else if(!web && silk_walking)
		add_movespeed_modifier(/datum/movespeed_modifier/tarantula_web)
		silk_walking = FALSE

/**
 * # Spider Viper
 *
 * The assassin of spider subtypes.  Essentially a juiced up version of the hunter.
 *
 * A subtype of the giant spider which specializes in speed and poison.  Injects a deadlier toxin than other spiders, moves extremely fast,
 * but like the hunter has a limited amount of health.
 */
/mob/living/simple_animal/hostile/poison/giant_spider/viper
	name = "черная вдова"
	desc = "Крайне быстрая и ядовитая тварь с очень опасным токсином, слава богам встречается довольно редко."
	icon_state = "viper"
	icon_living = "viper"
	icon_dead = "viper_dead"
	maxHealth = 40
	health = 40
	melee_damage_lower = 5
	melee_damage_upper = 5
	poison_per_bite = 5
	move_to_delay = 4
	poison_type = /datum/reagent/toxin/venom
	speed = -0.5
	gold_core_spawnable = NO_SPAWN

/**
 * # Spider Broodmother
 *
 * The reproductive line of spider subtypes.  Is the only subtype to lay eggs, which is the only way for spiders to reproduce.
 *
 * A subtype of the giant spider which is the crux of a spider horde.  Can lay normal eggs at any time which become normal spider types,
 * but by consuming human bodies can lay special eggs which can become one of the more specialized subtypes, including possibly another broodmother.
 * However, this spider subtype has no offensive capability and can be quickly dispatched without assistance from other spiders.  They are also capable
 * of sending messages to all living spiders, being a communication line for the rest of the horde.
 */
/mob/living/simple_animal/hostile/poison/giant_spider/midwife
	name = "королева роя"
	desc = "Редчайшая особь с зачатками интеллекта и псионическими способностями позволяющими ей контролировать других пауков, как правило королеву можно найти только в очень крупных гнездах, но даже одна особь может погубить станцию."
	gender = FEMALE
	icon_state = "midwife"
	icon_living = "midwife"
	icon_dead = "midwife_dead"
	maxHealth = 40
	health = 40
	melee_damage_lower = 5
	melee_damage_upper = 10
	poison_per_bite = 3
	gold_core_spawnable = NO_SPAWN
	///If the spider пытается cocoon something, what that something is.
	var/atom/movable/cocoon_target
	///How many humans this spider has drained but not layed enriched eggs for.
	var/fed = 0
	///The ability for the spider to wrap targets.
	var/obj/effect/proc_holder/wrap/wrap
	///The ability for the spider to lay basic eggs.
	var/datum/action/innate/spider/lay_eggs/lay_eggs
	///The ability for the spider to lay enriched eggs.
	var/datum/action/innate/spider/lay_eggs/enriched/lay_eggs_enriched
	///The ability for the spider to set a directive, a message shown to the child spider player when the player takes control.
	var/datum/action/innate/spider/set_directive/set_directive
	///A shared list of all the mobs consumed by any spider so that the same target can't be drained several times.
	var/static/list/consumed_mobs = list() //the tags of mobs that have been consumed by nurse spiders to lay eggs
	///The ability for the spider to send a message to all currently living spiders.
	var/datum/action/innate/spider/comm/letmetalkpls

/mob/living/simple_animal/hostile/poison/giant_spider/midwife/Initialize(mapload)
	. = ..()
	wrap = new
	AddAbility(wrap)
	lay_eggs = new
	lay_eggs.Grant(src)
	lay_eggs_enriched = new
	lay_eggs_enriched.Grant(src)
	set_directive = new
	set_directive.Grant(src)
	letmetalkpls = new
	letmetalkpls.Grant(src)

/**
 * Attempts to cocoon the spider's current cocoon_target.
 *
 * Attempts to coccon the spider's cocoon_target after a do_after.
 * If the target is a human who hasn't been drained before, ups the spider's fed counter so it can lay enriched eggs.
 */
/mob/living/simple_animal/hostile/poison/giant_spider/midwife/proc/cocoon()
	if(stat == DEAD || !cocoon_target || cocoon_target.anchored)
		return
	if(cocoon_target == src)
		to_chat(src, span_warning("Зачем опутывать себя же?"))
		return
	if(istype(cocoon_target, /mob/living/simple_animal/hostile/poison/giant_spider))
		to_chat(src, span_warning("Зачем опутывать собратьев?"))
		return
	if(!Adjacent(cocoon_target))
		to_chat(src, span_warning("[cocoon_target] слишком далеко!"))
		return
	if(is_busy)
		to_chat(src, span_warning("Я занята!"))
		return
	is_busy = TRUE
	visible_message(span_notice("[src] выпускает липкую субстанцию и начинает опутывать [cocoon_target] в кокон.") ,span_notice("Начинаю опутывать [cocoon_target] в кокон."))
	stop_automated_movement = TRUE
	if(do_after(src, 50, target = cocoon_target))
		if(is_busy)
			var/obj/structure/spider/cocoon/casing = new(cocoon_target.loc)
			if(isliving(cocoon_target))
				var/mob/living/living_target = cocoon_target
				if(ishuman(living_target) && (living_target.stat != DEAD || !consumed_mobs[living_target.tag])) //if they're not dead, you can consume them anyway
					consumed_mobs[living_target.tag] = TRUE
					fed++
					lay_eggs_enriched.UpdateButtonIcon(TRUE)
					visible_message(span_danger("[src] опутывает [living_target] в кокон.") ,span_notice("[living_target] послужит хорошим кормом для потомства, осталось только отложить яйца."))
					living_target.death() //you just ate them, they're dead.
				else
					to_chat(src, span_warning("[living_target] уже истощен и врятли сможет накормить новых паучат!"))
			cocoon_target.forceMove(casing)
			if(cocoon_target.density || ismob(cocoon_target))
				casing.icon_state = pick("cocoon_large1","cocoon_large2","cocoon_large3")
	cocoon_target = null
	is_busy = FALSE
	stop_automated_movement = FALSE

/datum/action/innate/spider
	icon_icon = 'icons/mob/actions/actions_animal.dmi'
	background_icon_state = "bg_alien"

/datum/action/innate/spider/lay_web
	name = "Сплести паутину"
	desc = "Хорошее средство для защиты гнезда, замедляет потенциальных недоброжелателей и не препятствует движению пауков."
	check_flags = AB_CHECK_CONSCIOUS
	button_icon_state = "lay_web"

/datum/action/innate/spider/lay_web/Activate()
	if(!istype(owner, /mob/living/simple_animal/hostile/poison/giant_spider))
		return
	var/mob/living/simple_animal/hostile/poison/giant_spider/spider = owner

	if(!isturf(spider.loc))
		return
	var/turf/spider_turf = get_turf(spider)

	var/obj/structure/spider/stickyweb/web = locate() in spider_turf
	if(web)
		to_chat(spider, span_warning("Тут уже есть паутина!"))
		return

	if(!spider.is_busy)
		spider.is_busy = TRUE
		spider.visible_message(span_notice("[spider] начинает выделять липкую субстанцию.") ,span_notice("Начинаю плести паутину..."))
		spider.stop_automated_movement = TRUE
		if(do_after(spider, 40 * spider.web_speed, target = spider_turf))
			if(spider.is_busy && spider.loc == spider_turf)
				new /obj/structure/spider/stickyweb(spider_turf)
		spider.is_busy = FALSE
		spider.stop_automated_movement = FALSE
	else
		to_chat(spider, span_warning("Я занята!"))

/obj/effect/proc_holder/wrap
	name = "Опутать"
	panel = "Spider"
	desc = "Позволяет оплести жертву паутиной и тем самым подготовить ее в качестве пищи для паучат гвардейцев."
	ranged_mousepointer = 'icons/effects/mouse_pointers/wrap_target.dmi'
	action_icon = 'icons/mob/actions/actions_animal.dmi'
	action_icon_state = "wrap_0"
	action_background_icon_state = "bg_alien"

/obj/effect/proc_holder/wrap/update_icon()
	action.button_icon_state = "wrap_[active]"
	action.UpdateButtonIcon()
	return ..()

/obj/effect/proc_holder/wrap/Click()
	if(!istype(usr, /mob/living/simple_animal/hostile/poison/giant_spider/midwife))
		return TRUE
	var/mob/living/simple_animal/hostile/poison/giant_spider/midwife/user = usr
	activate(user)
	return TRUE

/obj/effect/proc_holder/wrap/proc/activate(mob/living/user)
	var/message
	if(active)
		message = span_notice("Скрываю паутиновые железы.")
		remove_ranged_ability(message)
	else
		message = span_notice("Подготавливаю паутиновые железы. <B>Left-click your target to start wrapping!</B>")
		add_ranged_ability(user, message, TRUE)
		return TRUE

/obj/effect/proc_holder/wrap/InterceptClickOn(mob/living/caller, params, atom/target)
	if(..())
		return
	if(ranged_ability_user.incapacitated() || !istype(ranged_ability_user, /mob/living/simple_animal/hostile/poison/giant_spider/midwife))
		remove_ranged_ability()
		return

	var/mob/living/simple_animal/hostile/poison/giant_spider/midwife/user = ranged_ability_user

	if(user.Adjacent(target) && (ismob(target) || isobj(target)))
		var/atom/movable/target_atom = target
		if(target_atom.anchored)
			return
		user.cocoon_target = target_atom
		INVOKE_ASYNC(user, /mob/living/simple_animal/hostile/poison/giant_spider/midwife/.proc/cocoon)
		remove_ranged_ability()
		return TRUE

/obj/effect/proc_holder/wrap/on_lose(mob/living/carbon/user)
	remove_ranged_ability()

/datum/action/innate/spider/lay_eggs
	name = "Отложить паучью кладку"
	desc = "Откладывает яйца, из которых вскоре вылупятся обычные паучата."
	check_flags = AB_CHECK_CONSCIOUS
	button_icon_state = "lay_eggs"
	var/enriched = FALSE

/datum/action/innate/spider/lay_eggs/IsAvailable()
	. = ..()
	if(!.)
		return
	if(!istype(owner, /mob/living/simple_animal/hostile/poison/giant_spider/midwife))
		return FALSE
	var/mob/living/simple_animal/hostile/poison/giant_spider/midwife/S = owner
	if(enriched && !S.fed)
		return FALSE
	return TRUE

/datum/action/innate/spider/lay_eggs/Activate()
	if(!istype(owner, /mob/living/simple_animal/hostile/poison/giant_spider/midwife))
		return
	var/mob/living/simple_animal/hostile/poison/giant_spider/midwife/spider = owner

	var/obj/structure/spider/eggcluster/eggs = locate() in get_turf(spider)
	if(eggs)
		to_chat(spider, span_warning("Это место уже занято!"))
	else if(enriched && !spider.fed)
		to_chat(spider, span_warning("Детенышам не хватит еды!"))
	else if(!spider.is_busy)
		spider.is_busy = TRUE
		spider.visible_message(span_notice("[spider] начинает откладывать яйца.") ,span_notice("Начинаю откладывать яйца..."))
		spider.stop_automated_movement = TRUE
		if(do_after(spider, 100, target = get_turf(spider)))
			if(spider.is_busy)
				eggs = locate() in get_turf(spider)
				if(!eggs || !isturf(spider.loc))
					var/egg_choice = enriched ? /obj/effect/mob_spawn/spider/enriched : /obj/effect/mob_spawn/spider
					var/obj/effect/mob_spawn/spider/new_eggs = new egg_choice(get_turf(spider))
					new_eggs.directive = spider.directive
					new_eggs.faction = spider.faction
					if(enriched)
						spider.fed--
					UpdateButtonIcon(TRUE)
		spider.is_busy = FALSE
		spider.stop_automated_movement = FALSE

/datum/action/innate/spider/lay_eggs/enriched
	name = "Отложить гвардейскую кладку"
	desc = "Откладывает яйца, из которых вскоре вылупятся редкие элитные паучата. Требует по соседству кокон с опутанной жертвой для пропитания потомства."
	button_icon_state = "lay_enriched_eggs"
	enriched = TRUE

/datum/action/innate/spider/set_directive
	name = "Установить директиву"
	desc = "Установите директиву которой будут следовать ваши дети."
	check_flags = AB_CHECK_CONSCIOUS
	button_icon_state = "directive"

/datum/action/innate/spider/set_directive/IsAvailable()
	if(..())
		if(!istype(owner, /mob/living/simple_animal/hostile/poison/giant_spider))
			return FALSE
		return TRUE

/datum/action/innate/spider/set_directive/Activate()
	if(!istype(owner, /mob/living/simple_animal/hostile/poison/giant_spider/midwife))
		return
	var/mob/living/simple_animal/hostile/poison/giant_spider/midwife/spider = owner
	spider.directive = stripped_input(spider, "Установите новую директиву", "Создайте директиву", "[spider.directive]")
	message_admins("[ADMIN_LOOKUPFLW(owner)] паукам была задана директива: '[spider.directive]'.")
	log_game("[key_name(owner)] паукам была задана директива: '[spider.directive]'.")

/datum/action/innate/spider/comm
	name = "Приказ"
	desc = "Отдать приказ всем паукам."
	button_icon_state = "command"

/datum/action/innate/spider/comm/IsAvailable()
	if(!istype(owner, /mob/living/simple_animal/hostile/poison/giant_spider/midwife))
		return FALSE
	return TRUE

/datum/action/innate/spider/comm/Trigger(trigger_flags)
	var/input = stripped_input(owner, "Введите приказ для вашего легиона.", "Приказ", "")
	if(QDELETED(src) || !input || !IsAvailable())
		return FALSE
	spider_command(owner, input)
	return TRUE

/**
 * Sends a message to all spiders from the target.
 *
 * Allows the user to send a message to all spiders that exist.  Ghosts will also see the message.
 * Arguments:
 * * user - The spider sending the message
 * * message - The message to be sent
 */
/datum/action/innate/spider/comm/proc/spider_command(mob/living/user, message)
	if(!message)
		return
	var/my_message
	my_message = span_spider("<b>Приказ от [user]:</b> [message]")
	for(var/mob/living/simple_animal/hostile/poison/giant_spider/spider in GLOB.spidermobs)
		to_chat(spider, my_message)
	for(var/ghost in GLOB.dead_mob_list)
		var/link = FOLLOW_LINK(ghost, user)
		to_chat(ghost, "[link] [my_message]")
	usr.log_talk(message, LOG_SAY, tag="spider command")

/**
 * # Giant Ice Spider
 *
 * A giant spider immune to temperature damage.  Injects frost oil.
 *
 * A subtype of the giant spider which is immune to temperature damage, unlike its normal counterpart.
 * Currently unused in the game unless spawned by admins.
 */
/mob/living/simple_animal/hostile/poison/giant_spider/ice
	name = "огромный морозный паук"
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500
	poison_type = /datum/reagent/consumable/frostoil
	color = rgb(114,228,250)
	gold_core_spawnable = NO_SPAWN

/**
 * # Ice Nurse Spider
 *
 * A nurse spider immune to temperature damage.  Injects frost oil.
 *
 * Same thing as the giant ice spider but mirrors the nurse subtype.  Also unused.
 */
/mob/living/simple_animal/hostile/poison/giant_spider/nurse/ice
	name = "ледяная фрейлина"
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500
	poison_type = /datum/reagent/consumable/frostoil
	color = rgb(114,228,250)

/**
 * # Ice Hunter Spider
 *
 * A hunter spider immune to temperature damage.  Injects frost oil.
 *
 * Same thing as the giant ice spider but mirrors the hunter subtype.  Also unused.
 */
/mob/living/simple_animal/hostile/poison/giant_spider/hunter/ice
	name = "морозный паук охотник"
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500
	poison_type = /datum/reagent/consumable/frostoil
	color = rgb(114,228,250)
	gold_core_spawnable = NO_SPAWN

/**
 * # Flesh Spider
 *
 * A giant spider subtype specifically created by changelings.  Built to be self-sufficient, unlike other spider types.
 *
 * A subtype of giant spider which only occurs from changelings.  Has the base stats of a hunter, but they can heal themselves.
 * They also produce web in 70% of the time of the base spider.  They also occasionally leave puddles of blood when they walk around.  Flavorful!
 */
/mob/living/simple_animal/hostile/poison/giant_spider/hunter/flesh
	name = "кровавый паук"
	desc = "Маленькое мясистое существо в форме паука. Его глаза черны как смоль и горят ненавистью."
	icon_state = "flesh_spider"
	icon_living = "flesh_spider"
	icon_dead = "flesh_spider_dead"
	web_speed = 0.7

/mob/living/simple_animal/hostile/poison/giant_spider/hunter/flesh/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change = TRUE)
	. = ..()
	if(prob(5))
		new /obj/effect/decal/cleanable/blood/bubblegum(loc)

/mob/living/simple_animal/hostile/poison/giant_spider/hunter/flesh/AttackingTarget()
	if(is_busy)
		return
	if(src == target)
		if(health >= maxHealth)
			to_chat(src, span_warning("Мое тело в порядке и не нуждается в восстановлении."))
			return
		visible_message(span_notice("[src] заращивает на себе раны...") ,span_notice("Начинаю заращивать свои раны..."))
		is_busy = TRUE
		if(do_after(src, 20, target = src))
			heal_overall_damage(50, 50)
			new /obj/effect/temp_visual/heal(get_turf(src), "#80F5FF")
			visible_message(span_notice("[src] восстановился.") ,span_notice("Мне лучше."))
		is_busy = FALSE
		return
	return ..()

/**
 * # Viper Spider (Wizard)
 *
 * A viper spider buffed slightly so I don't need to hear anyone complain about me nerfing an already useless wizard ability.
 *
 * A viper spider with buffed attributes.  All I changed was its health value and gave it the ability to ventcrawl.  The crux of the wizard meta.
 */
/mob/living/simple_animal/hostile/poison/giant_spider/viper/wizard
	maxHealth = 80
	health = 80
	ventcrawler = VENTCRAWLER_ALWAYS
