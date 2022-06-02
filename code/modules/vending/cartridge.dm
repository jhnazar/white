//This one's from bay12
/obj/machinery/vending/cart
	name = "PTech"
	desc = "Картриджи для КПК."
	product_slogans = "Тележка поехала!"
	icon_state = "cart"
	icon_deny = "cart-deny"
	products = list(
		/obj/item/computer_hardware/hard_drive/portable/medical = 10,
		/obj/item/computer_hardware/hard_drive/portable/engineering = 10,
		/obj/item/computer_hardware/hard_drive/portable/security = 10,
		/obj/item/computer_hardware/hard_drive/portable/ordnance = 10,
		/obj/item/computer_hardware/hard_drive/portable/quartermaster = 10,
		/obj/item/computer_hardware/hard_drive/portable/command/captain = 3,
		/obj/item/modular_computer/tablet/pda/heads = 10,
	)
	refill_canister = /obj/item/vending_refill/cart
	default_price = PAYCHECK_COMMAND
	extra_price = PAYCHECK_COMMAND * 1.5
	payment_department = ACCOUNT_SRV
	light_mask="cart-light-mask"

/obj/item/vending_refill/cart
	machine_name = "PTech"
	icon_state = "refill_smoke"
