/obj/machinery/atmospherics/components/unary
	icon = 'icons/obj/atmospherics/components/unary_devices.dmi'
	dir = SOUTH
	initialize_directions = SOUTH
	device_type = UNARY
	pipe_flags = PIPING_ONE_PER_TURF
	construction_type = /obj/item/pipe/directional

/obj/machinery/atmospherics/components/unary/set_init_directions()
	initialize_directions = dir

/obj/machinery/atmospherics/components/unary/on_construction()
	..()
	update_icon()
