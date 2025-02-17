/datum/round_event_control/anomaly/anomaly_hallucination
	name = "Аномалия: Галюциногенная"
	typepath = /datum/round_event/anomaly/anomaly_hallucination

	min_players = 10
	max_occurrences = 5
	weight = 20

/datum/round_event/anomaly/anomaly_hallucination
	startWhen = 10
	announceWhen = 3
	anomaly_path = /obj/effect/anomaly/hallucination

/datum/round_event/anomaly/anomaly_hallucination/announce(fake)
	priority_announce("Обнаружено гипнотическое излучение неизвестной природы. Ожидаемое место появления: [impact_area.name].", "Аномальная тревога")
