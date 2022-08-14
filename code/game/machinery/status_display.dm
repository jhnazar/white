// Status display
// (formerly Countdown timer display)

GLOBAL_VAR_INIT(display_font_color, pick("#09f", "#f90", "#5f5", "#fff", "#f55", "#f5f"))

#define CHARS_PER_LINE 5
#define FONT_SIZE "5pt"
#define FONT_STYLE "Small Fonts"
#define SCROLL_RATE (0.04 SECONDS) // time per pixel
#define LINE1_Y -8
#define LINE2_Y -15

#define SD_BLANK 0  // 0 = Blank
#define SD_EMERGENCY 1  // 1 = Emergency Shuttle timer
#define SD_MESSAGE 2  // 2 = Arbitrary message(s)
#define SD_PICTURE 3  // 3 = alert picture
#define SD_TIME 4  // 4 = current time

#define SD_AI_EMOTE 1  // 1 = AI emoticon
#define SD_AI_BSOD 2  // 2 = Blue screen of death

/// Status display which can show images and scrolling text.
/obj/machinery/status_display
	name = "дисплей"
	desc = null
	icon = 'icons/obj/status_display.dmi'
	icon_state = "frame"
	density = FALSE

	layer = SIGN_LAYER

	var/obj/effect/overlay/status_display_text/message1_overlay
	var/obj/effect/overlay/status_display_text/message2_overlay

/// Immediately blank the display.
/obj/machinery/status_display/proc/remove_display()
	cut_overlays()
	vis_contents.Cut()
	if(message1_overlay)
		QDEL_NULL(message1_overlay)
	if(message2_overlay)
		QDEL_NULL(message2_overlay)

/// Immediately change the display to the given picture.
/obj/machinery/status_display/proc/set_picture(state)
	remove_display()
	add_overlay(state)

/// Immediately change the display to the given two lines.
/obj/machinery/status_display/proc/update_display(line1, line2)
	line1 = uppertext(line1)
	line2 = uppertext(line2)
	if( \
		(message1_overlay && message1_overlay.message == line1) && \
		(message2_overlay && message2_overlay.message == line2) \
	)
		return

	remove_display()

	message1_overlay = new(LINE1_Y, line1)
	vis_contents += message1_overlay

	message2_overlay = new(LINE2_Y, line2)
	vis_contents += message2_overlay

// Timed process - performs nothing in the base class
/obj/machinery/status_display/process()
	if(machine_stat & NOPOWER)
		// No power, no processing.
		remove_display()

	return PROCESS_KILL

/// Update the display and, if necessary, re-enable processing.
/obj/machinery/status_display/proc/update()
	if (process(SSMACHINES_DT) != PROCESS_KILL)
		START_PROCESSING(SSmachines, src)

/obj/machinery/status_display/power_change()
	. = ..()
	update()

/obj/machinery/status_display/emp_act(severity)
	. = ..()
	if(machine_stat & (NOPOWER|BROKEN) || . & EMP_PROTECT_SELF)
		return
	set_picture("ai_bsod")

/obj/machinery/status_display/examine(mob/user)
	. = ..()
	if (message1_overlay || message2_overlay)
		. += "<hr>Дисплей сообщает:"
		if (message1_overlay.message)
			. += "<br>\t<tt>[html_encode(message1_overlay.message)]</tt>"
		if (message2_overlay.message)
			. += "<br>\t<tt>[html_encode(message2_overlay.message)]</tt>"

// Helper procs for child display types.
/obj/machinery/status_display/proc/display_shuttle_status(obj/docking_port/mobile/shuttle)
	if(!shuttle)
		// the shuttle is missing - no processing
		update_display("шаттл?","")
		return PROCESS_KILL
	else if(shuttle.timer)
		var/line1 = "-[shuttle.getModeStr()]-"
		var/line2 = shuttle.getTimerStr()

		if(length_char(line2) > CHARS_PER_LINE)
			line2 = "ошибка"
		update_display(line1, line2)
	else
		// don't kill processing, the timer might turn back on
		remove_display()

/obj/machinery/status_display/proc/examine_shuttle(mob/user, obj/docking_port/mobile/shuttle)
	if (shuttle)
		var/modestr = shuttle.getModeStr()
		if (modestr)
			if (shuttle.timer)
				modestr = "<br>\t<tt>[modestr]: [shuttle.getTimerStr()]</tt>"
			else
				modestr = "<br>\t<tt>[modestr]</tt>"
		return "<hr>Дисплей сообщает:<br>\t<tt>[shuttle.name]</tt>[modestr]"
	else
		return "<hr>Дисплей сообщает:<br>\t<tt>Не обнаружен шаттл!</tt>"

/**
 * Nice overlay to make text smoothly scroll with no client updates after setup.
 */
/obj/effect/overlay/status_display_text
	icon = 'icons/obj/status_display.dmi'
	vis_flags = VIS_INHERIT_LAYER | VIS_INHERIT_PLANE | VIS_INHERIT_ID

	var/message = ""

/obj/effect/overlay/status_display_text/New(yoffset, line)
	maptext_y = yoffset
	message = line

	var/line_length = length_char(line)

	if(line_length > CHARS_PER_LINE)
		// Marquee text
		var/marquee_message = "[line] • [line] • [line]"
		var/marqee_length = line_length * 3 + 6
		maptext = generate_text(marquee_message, center = FALSE)
		maptext_width = 6 * marqee_length
		maptext_x = 32

		// Mask off to fit in screen.
		add_filter("mask", 1, alpha_mask_filter(icon = icon(icon, "outline")))

		// Scroll.
		var/width = 4 * marqee_length
		var/time = (width + 32) * SCROLL_RATE
		animate(src, maptext_x = -width, time = time, loop = -1)
		animate(maptext_x = 32, time = 0)
	else
		// Centered text
		maptext = generate_text(line, center = TRUE)
		maptext_x = 0

/obj/effect/overlay/status_display_text/proc/generate_text(text, center)
	return {"<div style="font-size:[FONT_SIZE];color:[GLOB.display_font_color];font:'[FONT_STYLE]'[center ? ";text-align:center" : ""]" valign="top">[text]</div>"}


/// Evac display which shows shuttle timer or message set by Command.
/obj/machinery/status_display/evac
	var/frequency = FREQ_STATUS_DISPLAYS
	var/mode = SD_TIME
	var/friendc = FALSE      // track if Friend Computer mode
	var/last_picture  // For when Friend Computer mode is undone

/obj/machinery/status_display/evac/directional/north
	dir = SOUTH
	pixel_y = 32

/obj/machinery/status_display/evac/directional/south
	dir = NORTH
	pixel_y = -32

/obj/machinery/status_display/evac/directional/east
	dir = WEST
	pixel_x = 32

/obj/machinery/status_display/evac/directional/west
	dir = EAST
	pixel_x = -32

/obj/machinery/status_display/evac/Initialize(mapload)
	. = ..()
	// register for radio system
	SSradio.add_object(src, frequency)

/obj/machinery/status_display/evac/Destroy()
	SSradio.remove_object(src,frequency)
	return ..()

/obj/machinery/status_display/evac/process()
	if(machine_stat & NOPOWER)
		// No power, no processing.
		remove_display()
		return PROCESS_KILL

	if(friendc) //Makes all status displays except supply shuttle timer display the eye -- Urist
		set_picture("ai_friend")
		return PROCESS_KILL

	switch(mode)
		if(SD_BLANK)
			remove_display()
			return PROCESS_KILL

		if(SD_EMERGENCY)
			return display_shuttle_status(SSshuttle.emergency)

		if(SD_TIME)
			return update_display("ВРЕМЯ", SSday_night.get_twentyfourhour_timestamp())

		if(SD_MESSAGE)
			return PROCESS_KILL

		if(SD_PICTURE)
			set_picture(last_picture)
			return PROCESS_KILL

/obj/machinery/status_display/evac/examine(mob/user)
	. = ..()
	if(mode == SD_EMERGENCY)
		. += examine_shuttle(user, SSshuttle.emergency)
	else if(!message1_overlay && !message2_overlay)
		. += "<hr>Дисплей пуст."

/obj/machinery/status_display/evac/receive_signal(datum/signal/signal)
	switch(signal.data["command"])
		if("blank")
			mode = SD_BLANK
			remove_display()
		if("time")
			mode = SD_TIME
			update_display("ВРЕМЯ", SSday_night.get_twentyfourhour_timestamp())
		if("shuttle")
			mode = SD_EMERGENCY
			remove_display()
		if("message")
			mode = SD_MESSAGE
			update_display(signal.data["msg1"], signal.data["msg2"])
		if("alert")
			mode = SD_PICTURE
			last_picture = signal.data["picture_state"]
			set_picture(last_picture)
		if("friendcomputer")
			friendc = !friendc
	update()


/// Supply display which shows the status of the supply shuttle.
/obj/machinery/status_display/supply
	name = "дисплей снабжения"

/obj/machinery/status_display/supply/process()
	if(machine_stat & NOPOWER)
		// No power, no processing.
		remove_display()
		return PROCESS_KILL

	var/line1
	var/line2
	if(!SSshuttle.supply)
		// Might be missing in our first update on initialize before shuttles
		// have loaded. Cross our fingers that it will soon return.
		line1 = "КАРГО"
		line2 = "щаттл?"
	else if(SSshuttle.supply.mode == SHUTTLE_IDLE)
		if(is_station_level(SSshuttle.supply.z))
			line1 = "КАРГО"
			line2 = "В доке"
	else
		line1 = "КАРГО"
		line2 = SSshuttle.supply.getTimerStr()
		if(length_char(line2) > CHARS_PER_LINE)
			line2 = "Ошибка"
	update_display(line1, line2)

/obj/machinery/status_display/supply/examine(mob/user)
	. = ..()
	var/obj/docking_port/mobile/shuttle = SSshuttle.supply
	var/shuttleMsg = null
	if (shuttle.mode == SHUTTLE_IDLE)
		if (is_station_level(shuttle.z))
			shuttleMsg = "В доке"
	else
		shuttleMsg = "[shuttle.getModeStr()]: [shuttle.getTimerStr()]"
	if (shuttleMsg)
		. += "<hr>Дисплей сообщает:<br>\t<tt>[shuttleMsg]</tt>"
	else
		. += "<hr>Дисплей пуст."


/// General-purpose shuttle status display.
/obj/machinery/status_display/shuttle
	name = "дисплей шаттла"
	var/shuttle_id

/obj/machinery/status_display/shuttle/process()
	if(!shuttle_id || (machine_stat & NOPOWER))
		// No power, no processing.
		remove_display()
		return PROCESS_KILL

	return display_shuttle_status(SSshuttle.getShuttle(shuttle_id))

/obj/machinery/status_display/shuttle/examine(mob/user)
	. = ..()
	if(shuttle_id)
		. += examine_shuttle(user, SSshuttle.getShuttle(shuttle_id))
	else
		. += "<hr>Дисплей пуст."

/obj/machinery/status_display/shuttle/vv_edit_var(var_name, var_value)
	. = ..()
	if(!.)
		return
	switch(var_name)
		if(NAMEOF(src, shuttle_id))
			update()

/obj/machinery/status_display/shuttle/connect_to_shuttle(obj/docking_port/mobile/port, obj/docking_port/stationary/dock)
	if(port)
		shuttle_id = port.id
	update()


/// Pictograph display which the AI can use to emote.
/obj/machinery/status_display/ai
	name = "дисплей ИИ"
	desc = "Небольшой экран, которым управляет ИИ."

	var/mode = SD_TIME
	var/emotion = "Neutral"

/obj/machinery/status_display/ai/directional/north
	dir = SOUTH
	pixel_y = 32

/obj/machinery/status_display/ai/directional/south
	dir = NORTH
	pixel_y = -32

/obj/machinery/status_display/ai/directional/east
	dir = WEST
	pixel_x = 32

/obj/machinery/status_display/ai/directional/west
	dir = EAST
	pixel_x = -32

/obj/machinery/status_display/ai/Initialize(mapload)
	. = ..()
	GLOB.ai_status_displays.Add(src)

/obj/machinery/status_display/ai/Destroy()
	GLOB.ai_status_displays.Remove(src)
	. = ..()

/obj/machinery/status_display/ai/attack_ai(mob/living/silicon/ai/user)
	if(isAI(user))
		user.ai_statuschange()

/obj/machinery/status_display/ai/process()
	if(mode == SD_BLANK || (machine_stat & NOPOWER))
		remove_display()
		return PROCESS_KILL

	if(mode == SD_AI_EMOTE)
		switch(emotion)
			if("Very Happy")
				set_picture("ai_veryhappy")
			if("Happy")
				set_picture("ai_happy")
			if("Neutral")
				set_picture("ai_neutral")
			if("Unsure")
				set_picture("ai_unsure")
			if("Confused")
				set_picture("ai_confused")
			if("Sad")
				set_picture("ai_sad")
			if("BSOD")
				set_picture("ai_bsod")
			if("Blank")
				set_picture("ai_off")
			if("Problems?")
				set_picture("ai_trollface")
			if("Awesome")
				set_picture("ai_awesome")
			if("Dorfy")
				set_picture("ai_urist")
			if("Thinking")
				set_picture("ai_thinking")
			if("Facepalm")
				set_picture("ai_facepalm")
			if("Friend Computer")
				set_picture("ai_friend")
			if("Blue Glow")
				set_picture("ai_sal")
			if("Red Glow")
				set_picture("ai_hal")
		return PROCESS_KILL

	if(mode == SD_AI_BSOD)
		set_picture("ai_bsod")
		return PROCESS_KILL


#undef CHARS_PER_LINE
#undef FONT_SIZE
#undef FONT_STYLE
#undef SCROLL_RATE
#undef LINE1_Y
#undef LINE2_Y
