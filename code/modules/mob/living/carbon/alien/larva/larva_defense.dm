

/mob/living/carbon/alien/larva/attack_hand(mob/living/carbon/human/M)
	if(..())
		var/damage = rand(1, 9)
		if (prob(90))
			playsound(loc, "punch", 25, TRUE, -1)
			log_combat(M, src, "attacked")
			visible_message(span_danger("[M] kicks [src]!") , \
							span_userdanger("[M] kicks you!") , span_hear("Слышу звук разрывающейся плоти!") , COMBAT_MESSAGE_RANGE, M)
			to_chat(M, span_danger("You kick [src]!"))
			if ((stat != DEAD) && (damage > 4.9))
				Unconscious(rand(100,200))

			var/obj/item/bodypart/affecting = get_bodypart(ran_zone(M.zone_selected))
			apply_damage(damage, BRUTE, affecting)
		else
			playsound(loc, 'sound/weapons/punchmiss.ogg', 25, TRUE, -1)
			visible_message(span_danger("[M] kick misses [src]!") , \
							span_danger("You avoid [M] kick!") , span_hear("Слышу взмах!") , COMBAT_MESSAGE_RANGE, M)
			to_chat(M, span_warning("Your kick misses [src]!"))

/mob/living/carbon/alien/larva/attack_hulk(mob/living/carbon/human/user)
	. = ..()
	if(!.)
		return
	user.AddComponent(/datum/component/force_move, get_step_away(user,src, 30))

/mob/living/carbon/alien/larva/do_attack_animation(atom/A, visual_effect_icon, obj/item/used_item, no_effect)
	if(!no_effect && !visual_effect_icon)
		visual_effect_icon = ATTACK_EFFECT_BITE
	..()
