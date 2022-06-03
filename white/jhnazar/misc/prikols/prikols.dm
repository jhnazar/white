/*
 * Этот прок вызывается в проке призрака update_icon()
 * Если возвращает TRUE, то update_icon() у призрака не выполняется.
 */

/mob/dead/observer/proc/update_custom_icon()
	if(ckey == "jhnazar")
		icon = 'white/jhnazar/misc/prikols/ghost_icon.dmi'
		icon_state = "ghost_bee"
		desc = "Самая лучшая пчола на диком Вайте"
		return TRUE

	if(ckey == "kachyuorkin")
		icon = 'white/kacherkin/icons/gooost.dmi'
		icon_state = "ghost"
		name = "Слизнекот"
		deadchat_name = "Слизнекот"
		desc = "Кота слизь. Ты думал что-то здесь будет?"
		return TRUE

	if(ckey == "biomechanicmann")
		icon = 'white/jhnazar/misc/prikols/bee.dmi'
		icon_state = "syndiebee_wings"

		if(prob(50))
			icon_state = "syndiebee_wings"
		else
			if(prob(50))
				icon_state = "tophatbee_wings"
			else
				icon_state = "lichbee_wings"
		return TRUE

	return FALSE

/datum/emote/living/carbon/pishanie
	key = "pishat"
	ru_name = "пищать"
	key_third_person = "pishit"
	message = "пищит."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/pishanie/get_sound(mob/living/carbon/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!H.mind || !H.mind.miming)
			if(user.gender == FEMALE)
				return pick('white/qwaszx000/loly/pisk.ogg',\
							'white/jhnazar/misc/prikols/sjim1.ogg',\
							'white/jhnazar/misc/prikols/sjim2.ogg')
			else
				return 'white/jhnazar/misc/prikols/loly_male.ogg'
