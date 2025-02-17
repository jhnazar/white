/obj/docking_port/mobile/assault_pod
	name = "assault pod"
	id = "steel_rain"

/obj/docking_port/mobile/assault_pod/request(obj/docking_port/stationary/S)
	if(!(z in SSmapping.levels_by_trait(ZTRAIT_STATION))) //No launching pods that have already launched
		return ..()


/obj/docking_port/mobile/assault_pod/initiate_docking(obj/docking_port/stationary/S1)
	. = ..()
	if(!istype(S1, /obj/docking_port/stationary/transit))
		playsound(get_turf(src.loc), 'sound/effects/explosion1.ogg',50,1)



/obj/item/assault_pod
	name = "Assault Pod Targeting Device"
	icon = 'icons/obj/device.dmi'
	icon_state = "gangtool-red"
	inhand_icon_state = "radio"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	desc = "Used to select a landing zone for assault pods."
	var/shuttle_id = "steel_rain"
	var/dwidth = 3
	var/dheight = 0
	var/width = 7
	var/height = 7
	var/lz_dir = 1


/obj/item/assault_pod/attack_self(mob/living/user)
	var/target_area
	target_area = tgui_input_list(usr, "Area to land", "Select a Landing Zone", GLOB.teleportlocs, target_area)
	if(!target_area)
		return
	var/area/picked_area = GLOB.teleportlocs[target_area]
	if(!src || QDELETED(src))
		return

	var/turf/T = safepick(get_area_turfs(picked_area))
	if(!T)
		return
	var/obj/docking_port/stationary/landing_zone = new /obj/docking_port/stationary(T)
	landing_zone.id = "assault_pod([REF(src)])"
	landing_zone.name = "Landing Zone"
	landing_zone.dwidth = dwidth
	landing_zone.dheight = dheight
	landing_zone.width = width
	landing_zone.height = height
	landing_zone.setDir(lz_dir)

	for(var/obj/machinery/computer/shuttle_flight/S in GLOB.machines)
		if(S.shuttleId == shuttle_id)
			S.recall_docking_port_id = "[landing_zone.id]"
			S.valid_docks = list("[landing_zone.id]")

	to_chat(user, span_notice("Landing zone set."))

	qdel(src)
