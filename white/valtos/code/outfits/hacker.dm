/datum/outfit/job/hacker
	name = JOB_HACKER
	jobtype = /datum/job/hacker

	belt = /obj/item/storage/belt/utility/full
	l_pocket = /obj/item/modular_computer/tablet/pda/science
	ears = /obj/item/radio/headset/headset_sci
	glasses = /obj/item/clothing/glasses/hud/hacker_rig
	uniform = /obj/item/clothing/under/color/grey
	shoes = /obj/item/clothing/shoes/jackboots

	backpack = /obj/item/storage/backpack/science
	satchel = /obj/item/storage/backpack/satchel/tox

	backpack_contents = list()
	implants = list(/obj/item/implant/mindshield)

/datum/outfit/job/hacker/full
	name = "Hacker (Full)"

	belt = /obj/item/storage/belt/utility/chief/full
	gloves = /obj/item/clothing/gloves/combat/guard
	suit = /obj/item/clothing/suit/space/hacker_rig
	head = /obj/item/clothing/head/helmet/space/chronos/hacker

/datum/outfit/job/hacker/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()

	H.client << 'white/valtos/sounds/hacker_hello.ogg'

	ADD_TRAIT(H, TRAIT_HACKER, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_PACIFISM, JOB_TRAIT)

	H.add_client_colour(/datum/client_colour/hacker)
	H.hud_list[HACKER_HUD].icon = null
	H.alpha = 200

	var/datum/action/cooldown/spell/basic_heal/hacker/HH = new(src)
	HH.Grant(H)

	spawn(5 SECONDS)
		if(H?.hud_used)
			H.hud_used.update_parallax_pref(H)

		add_verb(H, /mob/living/carbon/proc/hackers_immortality)
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/hacker/head)
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/hacker/suit)
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/hacker/gloves)
