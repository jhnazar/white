/obj/item/storage/box/syndicate_team/PopulateContents()
	var/team_kit = pick("solo_sniper", "solo_spotter", "scammer1", "scammer2", "workplaceshooter1", "workplaceshooter2", "sniperspotter", "scammers", "workplaceshooter")
	switch(team_kit)
		if("solo_sniper")
			new /obj/item/storage/box/syndicate/sniper(src)
			new /obj/item/food/grown/banana(src)

		if("solo_spotter")
			new /obj/item/soap(src)
			new /obj/item/storage/box/syndicate/spotter(src)

		if("scammer1")
			new /obj/item/food/donut(src)
			new /obj/item/storage/box/syndicate/scammer(src)

		if("scammer2")
			new /obj/item/food/ready_donk/warm(src)
			new /obj/item/storage/box/syndicate/scammer(src)

		if("workplaceshooter1")
			new /obj/item/bikehorn(src)
			new /obj/item/storage/box/syndicate/shooteruzis(src)

		if("workplaceshooter2")
			new /obj/item/storage/box/syndicate/shootershotty(src)
			new /obj/item/toy/balloon(src)

		if("sniperspotter")
			new /obj/item/storage/box/syndicate/sniper(src)
			new /obj/item/storage/box/syndicate/spotter(src)

		if("scammers")
			new /obj/item/storage/box/syndicate/scammer(src)
			new /obj/item/storage/box/syndicate/scammer(src)

		if("workplaceshooter")
			new /obj/item/storage/box/syndicate/shootershotty(src)
			new /obj/item/storage/box/syndicate/shooteruzis(src)

/obj/item/storage/box/syndicate/sniper/PopulateContents()
	new /obj/item/radio/headset/syndicate/alt(src)
	new /obj/item/gun/ballistic/rifle/boltaction/hecate(src)
	new /obj/item/ammo_box/magazine/sniper_rounds/penetrator(src)
	new /obj/item/ammo_box/magazine/sniper_rounds/penetrator(src)


/obj/item/storage/box/syndicate/spotter/PopulateContents()
	new /obj/item/radio/headset/syndicate/alt(src)
	new /obj/item/binoculars(src)
	new /obj/item/gun/ballistic/automatic/pistol/deagle(src)
	new /obj/item/storage/belt/holster/nukie(src)
	new /obj/item/clothing/glasses/thermal/syndi(src)
	new /obj/item/ammo_box/magazine/m50(src)
	new /obj/item/ammo_box/magazine/m50(src)

/obj/item/storage/box/syndicate/scammer/PopulateContents() //это не говно теперь, но хуй знает догадаются ли..................
	new /obj/item/clothing/mask/chameleon(src)
	new /obj/item/gun/ballistic/automatic/wt550(src)
	new /obj/item/clothing/under/chameleon(src)
	new /obj/item/clothing/shoes/chameleon/noslip(src)
	new /obj/item/card/id/advanced/chameleon/black(src)
	new /obj/item/clothing/glasses/hud/security/sunglasses(src)
	new /obj/item/storage/secure/briefcase/syndie(src)
	new /obj/item/storage/secure/briefcase/syndie(src)
	new /obj/item/card/emag(src)
	new /obj/item/circuitboard/machine/ltsrbt(src)

/obj/item/storage/box/syndicate/shootershotty/PopulateContents()
	new /obj/item/gun/ballistic/shotgun/fallout/huntingshot/columbine(src)
	new /obj/item/storage/box/survival(src)
	new /obj/item/grenade/c4(src)
	new /obj/item/storage/box/lethalshot(src)
	new /obj/item/storage/box/lethalshot(src)
	new /obj/item/storage/box/lethalshot(src)
	new /obj/item/storage/belt/bandolier(src)
	new /obj/item/clothing/glasses/sunglasses(src)
	new /obj/item/clothing/gloves/fingerless(src)
	new /obj/item/clothing/under/syndicate(src)
	new /obj/item/clothing/suit/armor/vest/leather/noname(src)
	new /obj/item/clothing/shoes/combat(src)
	new /obj/item/switchblade(src)
	new /obj/item/clothing/head/soft/black/columbine(src)
	new /obj/effect/spawner/newbomb/timer/syndicate(src)

/obj/item/storage/box/syndicate/shooteruzis/PopulateContents()
	new /obj/item/gun/ballistic/automatic/mini_uzi(src)
	new /obj/item/ammo_box/magazine/uzim9mm(src)
	new /obj/item/ammo_box/magazine/uzim9mm(src)
	new /obj/item/storage/box/survival(src)
	new /obj/item/lighter/greyscale(src)
	new /obj/item/storage/fancy/cigarettes/cigpack_syndicate(src)
	new /obj/item/grenade/iedcasing(src)
	new /obj/item/grenade/iedcasing(src)
	new /obj/item/clothing/glasses/sunglasses(src)
	new /obj/item/clothing/gloves/fingerless(src)
	new /obj/item/clothing/under/syndicate(src)
	new /obj/item/clothing/suit/armor/vest/leather/noname(src)
	new /obj/item/clothing/shoes/combat(src)
	new /obj/item/switchblade(src)
	new /obj/item/clothing/head/soft/black/columbine(src)
