// Химия

// Протравка от заражения чужим и опухоли для рейнджеров, в дальнейшем переедет к паразитологу (возможно)

//	Зед добавка с побочными эффектами, ничего не делает кроме плохого, нужен для калибровки побочки, так же ослабляет ее если наниты отфильтруют вред

//datum/reagent/medicine/zed
/datum/reagent/toxin/zed
	name = "Зед-4"
	enname = "Zed-4"
	description = "Контрпаразитный препарат. Оказывает тяжелейшее угнетающее воздействие на организм."
	reagent_state = LIQUID
	color = "#046104"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	taste_description = "смерть"
	ph = 10
	chemical_flags = REAGENT_IGNORE_STASIS

/datum/reagent/toxin/zed/on_mob_add(mob/living/M, amount)
	. = ..()
	M.Knockdown(15 SECONDS * amount)
	M.Paralyze(15 SECONDS * amount)
	M.Dizzy(15 SECONDS * amount)
	M.Jitter(15 SECONDS * amount)
	M.hallucination += 75 * amount
	to_chat(M, span_userdanger("МНЕ ЧУДОВИЩНО ПЛОХО!!!"))
	M.overlay_fullscreen("depression", /atom/movable/screen/fullscreen/depression, 3)
	M.sound_environment_override = SOUND_ENVIRONMENT_PSYCHOTIC

/datum/reagent/toxin/zed/on_mob_life(mob/living/carbon/M, delta_time, times_fired)

	if(DT_PROB(50, delta_time))
		switch(rand(1, 11))
			if(1 to 3)
				M.emote("agony")
				M.adjustOrganLoss(ORGAN_SLOT_LIVER, 6, 60)
			if(4)
				M.vomit()
				M.adjustOrganLoss(ORGAN_SLOT_STOMACH, 7, 60)
			if(5 to 6)
				M.emote("twitch")
				M.adjustOrganLoss(ORGAN_SLOT_HEART, 7, 60)
			if(7 to 8)
				M.say("[pick("ПОМОГИТЕ МНЕ КТО-НИБУДЬ", "Я НЕ МОГУ БОЛЬШЕ ЭТО ВЫНЕСТИ", "УБЕЙТЕ МЕНЯ! Я НЕ ХОЧУ БОЛЬШЕ", "СУКА! Я НЕНАВИЖУ НАНОТРЕЙЗЕН", "ЛУЧШЕ БЫЛО СДОХНУТЬ", "Я УБЬЮ УРОДА КОТОРЫЙ ПРИДУМАЛ ЭТУ ХИМИЮ", "БОЛЬНО! СУКА КАК ЖЕ БОЛЬНО", "ТВАРИ! КАКИЕ ЖЕ ВЫ ВСЕ ТВАРИ!")]!", forced=name)
				M.adjustOrganLoss(ORGAN_SLOT_LUNGS, 7, 60)
			if(9 to 11)
				M.playsound_local(null, pick(CREEPY_SOUNDS), 100, 1)
				M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 3, 100)

		M.next_hallucination = 5

	..()

/datum/reagent/toxin/zed/on_mob_delete(mob/living/M)
	M.sound_environment_override = SOUND_ENVIRONMENT_NONE
	M.clear_fullscreen("depression")
	M.jitteriness = 30
	M.dizziness = 30
	M.hallucination = 30
	. = ..()

//	Раккун, от зомби, датум

/datum/reagent/medicine/raccoon
	name = "Раккун-2"
	enname = "Raccoon-2"
	description = "Подавляет опухоль Ромерола и излечивает от Зомби-вируса, однако оказывает тяжелейшее угнетающее воздействие на организм."
	reagent_state = LIQUID
	color = "#046104"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	taste_description = "смерть"
	ph = 10
	chemical_flags = REAGENT_IGNORE_STASIS

//	Протекание и лечение
/datum/reagent/medicine/raccoon/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	var/obj/item/organ/zombie_infection/zed_ozz = M.getorganslot(ORGAN_SLOT_ZOMBIE)
	if(current_cycle > 20)
		if(zed_ozz)
			qdel(zed_ozz)
	..()

//	Медипен Раккун
/obj/item/reagent_containers/hypospray/medipen/raccoon
	name = "Раккун-2"
	desc = "Подавляет опухоль Ромерола и излечивает от Зомби-вируса, однако оказывает тяжелейшее угнетающее воздействие на организм."
	icon = 'white/Feline/icons/syringe_zed.dmi'
	icon_state = "raccoon"
	inhand_icon_state = "tbpen"
	reagent_flags = null
	list_reagents = list(/datum/reagent/medicine/raccoon = 4, /datum/reagent/toxin/zed = 4)

/obj/item/reagent_containers/hypospray/medipen/raccoon/inject(mob/living/M, mob/user)
	to_chat(user, span_warning("Господи, как я не хочу этого делать..."))
	if(isliving(M))
		if(M != user)
			M.visible_message(span_danger("<b>[user]</b> пытается вколоть <b>[M]</b> медипен с угрожающей расцветкой!") , \
									span_userdanger("<b>[user]</b> пытается вколоть мне медипен с угрожающей расцветкой!"))
	if(do_after(user, 5 SECONDS, user))
		return ..()

//	Ностромо, от чужих, датум

/datum/reagent/medicine/nostromo
	name = "Ностромо-7"
	enname = "Nostromo-7"
	description = "Вытравливает эмбриона чужого из организма концентрированными щелочными соединениями, однако оказывает тяжелейшее угнетающее воздействие на организм."
	reagent_state = LIQUID
	color = "#046104"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	taste_description = "серная кислота"
	ph = 10
	chemical_flags = REAGENT_IGNORE_STASIS

//	Протекание и лечение
/datum/reagent/medicine/nostromo/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	var/obj/item/organ/body_egg/parasite_egg = M.getorganslot(ORGAN_SLOT_PARASITE_EGG)
	if(current_cycle > 20)
		if(parasite_egg)
			qdel(parasite_egg)
	..()

//	Медипен Ностромо
/obj/item/reagent_containers/hypospray/medipen/nostromo
	name = "Ностромо-7"
	desc = "Вытравливает эмбриона чужого из организма концентрированными щелочными соединениями, однако оказывает тяжелейшее угнетающее воздействие на организм."
	icon = 'white/Feline/icons/syringe_zed.dmi'
	icon_state = "Nostromo"
	inhand_icon_state = "tbpen"
	reagent_flags = null
	list_reagents = list(/datum/reagent/medicine/nostromo = 4, /datum/reagent/toxin/zed = 4)

/obj/item/reagent_containers/hypospray/medipen/nostromo/inject(mob/living/M, mob/user)
	to_chat(user, span_warning("Господи, как я не хочу этого делать..."))
	if(isliving(M))
		if(M != user)
			M.visible_message(span_danger("<b>[user]</b> пытается вколоть <b>[M]</b> медипен с угрожающей расцветкой!") , \
									span_userdanger("<b>[user]</b> пытается вколоть мне медипен с угрожающей расцветкой!"))
	if(do_after(user, 5 SECONDS, user))
		return ..()

//	Медипен Спутник Лайт
/obj/item/reagent_containers/hypospray/medipen/sputnik_lite
	name = "Спутник Лайт"
	desc = "Нейтрализует известные виды космических ксенопаразитов, оказывает менее губительное воздействие на организм в отличии от аналогов. Применять строго по назначению."
	icon = 'white/Feline/icons/syringe_zed.dmi'
	icon_state = "sputnik_lite"
	inhand_icon_state = "tbpen"
	reagent_flags = null
	list_reagents = list(/datum/reagent/medicine/nostromo = 4, /datum/reagent/medicine/raccoon = 4, /datum/reagent/toxin/zed = 2)

/obj/item/reagent_containers/hypospray/medipen/sputnik_lite/inject(mob/living/M, mob/user)
	to_chat(user, span_warning("Господи, как я не хочу этого делать..."))
	if(isliving(M))
		if(M != user)
			M.visible_message(span_danger("<b>[user]</b> пытается вколоть <b>[M]</b> медипен с угрожающей расцветкой!") , \
									span_userdanger("<b>[user]</b> пытается вколоть мне медипен с угрожающей расцветкой!"))
	if(do_after(user, 5 SECONDS, user))
		return ..()

// Препарат защищающий от заражения

/datum/reagent/medicine/saver
	name = "Спасатель"
	enname = "saver"
	description = "Сыворотка, разработанная для спецподразделений работающих в зонах подверженных ксеноугрозе. При применении мобилизует организм и препятствует развитию ксенопаразитов, однако не способна обратить заражение вспять."
	reagent_state = LIQUID
	color = "#ee3608"
	metabolization_rate = 0.085 * REAGENTS_METABOLISM
	taste_description = "запах гари и решительность"
	overdose_threshold = 15
	ph = 10
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/saver/overdose_process(mob/living/M, delta_time, times_fired)
	M.hallucination = clamp(M.hallucination + (5 * REM * delta_time), 0, 60)
	M.adjustToxLoss(0.2 * REM * delta_time, 0)
	..()
	. = TRUE

/datum/reagent/medicine/saver/on_mob_metabolize(mob/living/M, amount)
	. = ..()
	ADD_TRAIT(M, TRAIT_PARASITE_IMMUNE, name)
	to_chat(M, span_notice(pick("Я должен...", "Никто кроме нас...", "Это мой долг...", "Теперь моя очередь...", "Сам погибай, но товарища выручай...")))

/datum/reagent/medicine/saver/on_mob_end_metabolize(mob/living/M, amount)
	. = ..()
	REMOVE_TRAIT(M, TRAIT_PARASITE_IMMUNE, name)
	to_chat(M, span_warning("Чувствую как флёр героизма меня покидает..."))

/obj/item/reagent_containers/pill/saver
	name = "таблетка спасателя"
	desc = "Сыворотка, разработанная для спецподразделений работающих в зонах подверженных ксеноугрозе. При применении мобилизует организм и препятствует развитию ксенопаразитов, однако не способна обратить заражение вспять. По ребру таблетки выгравирована надпись \"Никто кроме нас...\""
	icon_state = "pill13"
	list_reagents = list(/datum/reagent/medicine/saver = 10)
	rename_with_volume = TRUE

/obj/item/reagent_containers/pill/saver/vip
	name = "завалявшаяся в кармане таблетка"
	desc = "Таблетка которую вам выдали в самом начале этой смены, кажется там что то говорили про принимать при угрозе заражения, но большую часть инструктажа вы как всегда проспали..."
	icon_state = "pill13"
	list_reagents = list(/datum/reagent/medicine/saver = 4)
	rename_with_volume = TRUE

/obj/item/storage/pill_bottle/saver
	name = "баночка с таблетками спасателя"
	desc = "Сыворотка, разработанная для спецподразделений работающих в зонах подверженных ксеноугрозе. При применении мобилизует организм и препятствует развитию ксенопаразитов, однако не способна обратить заражение вспять. ВНИМАНИЕ! Принимать не больше 1 таблетки раз в 10 минут."

/obj/item/storage/pill_bottle/saver/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/reagent_containers/pill/saver(src)

// Сенсорика
/obj/item/reagent_containers/pill/sens
	name = "Сенс-2"
	desc = "Витаминный комплекс помогающий при нарушении аудио-визуального восприятия."
	icon_state = "pill23"
	list_reagents = list(/datum/reagent/medicine/oculine = 10, /datum/reagent/medicine/inacusiate = 10)
	rename_with_volume = TRUE

/obj/item/storage/pill_bottle/sens
	name = "Сенс-2"
	desc = "Витаминный комплекс помогающий при нарушении аудио-визуального восприятия."
	icon_state = "pill_bottle_sens"

/obj/item/storage/pill_bottle/sens/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/reagent_containers/pill/sens(src)

/datum/reagent/medicine/space_stab
	name = "Пустотный стабилизатор"
	enname = "space stab"
	description = "Вызывает временную мутацию позволяющую безвредно находится в космосе."
	reagent_state = LIQUID
	color = "#410ea6"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	taste_description = "пустота"
	overdose_threshold = 15
	ph = 10
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	var/static/mutable_appearance/space_overlay = mutable_appearance('icons/effects/genetics.dmi', "fire2", -MUTATIONS_LAYER)

/datum/reagent/medicine/space_stab/on_mob_metabolize(mob/living/M, amount)
	. = ..()
	M.add_overlay(space_overlay)
	ADD_TRAIT(M, TRAIT_RESISTLOWPRESSURE, name)
	ADD_TRAIT(M, TRAIT_RESISTCOLD, name)
	to_chat(M, span_notice(pick("Чувствую себя, немного озябшим")))

/datum/reagent/medicine/space_stab/on_mob_end_metabolize(mob/living/M, amount)
	. = ..()
	M.cut_overlay(space_overlay)
	REMOVE_TRAIT(M, TRAIT_RESISTLOWPRESSURE, name)
	REMOVE_TRAIT(M, TRAIT_RESISTCOLD, name)
	to_chat(M, span_warning("Холод ушел"))

