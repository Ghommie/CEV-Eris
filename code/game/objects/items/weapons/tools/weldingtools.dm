/obj/item/weapon/tool/weldingtool
	name = "welding tool"
	icon_state = "welder"
	item_state = "welder"
	flags = CONDUCT
	force = WEAPON_FORCE_WEAK
	switched_on_force = WEAPON_FORCE_PAINFUL
	throwforce = WEAPON_FORCE_WEAK
	worksound = WORKSOUND_WELDING
	throw_speed = 1
	throw_range = 5
	matter = list(MATERIAL_STEEL = 5)
	origin_tech = list(TECH_ENGINEERING = 1)
	switched_on_qualities = list(QUALITY_WELDING = 30, QUALITY_CAUTERIZING = 10, QUALITY_WIRE_CUTTING = 10)

	sparks_on_use = TRUE
	eye_hazard = TRUE

	use_fuel_cost = 0.1
	max_fuel = 25

	toggleable = TRUE
	create_hot_spot = TRUE
	glow_color = COLOR_ORANGE

	heat = 2250


/obj/item/weapon/tool/weldingtool/turn_on(mob/user)

	if (get_fuel() > passive_fuel_cost)
		item_state = "[initial(item_state)]_on"
		user << SPAN_NOTICE("You switch [src] on.")
		playsound(loc, 'sound/items/welderactivate.ogg', 50, 1)
		..()
		damtype = BURN
		START_PROCESSING(SSobj, src)
	else
		item_state = initial(item_state)
		user << SPAN_WARNING("[src] has no fuel!")

	//Todo: Add a better hit sound for a turned_on welder

/obj/item/weapon/tool/weldingtool/turn_off(mob/user)
	item_state = initial(item_state)
	playsound(loc, 'sound/items/welderdeactivate.ogg', 50, 1)
	user << SPAN_NOTICE("You switch [src] off.")
	..()
	damtype = initial(damtype)


/obj/item/weapon/tool/weldingtool/is_hot()
	if (damtype == BURN)
		return heat


/obj/item/weapon/tool/weldingtool/improvised
	name = "jury-rigged torch"
	desc = "An assembly of pipes attached to a little gas tank. Serves capably as a welder, though a bit risky."
	icon_state = "welder"
	item_state = "welder"
	switched_on_force = WEAPON_FORCE_PAINFUL * 0.8
	max_fuel = 15
	switched_on_qualities = list(QUALITY_WELDING = 15, QUALITY_CAUTERIZING = 10, QUALITY_WIRE_CUTTING = 10)
	degradation = 1.5

//The improvised welding tool is created with a full tank of fuel.
//It's implied that it's burning the oxygen in the emergency tank that was used to create it
/obj/item/weapon/tool/weldingtool/improvised/Created()
	return


/obj/item/weapon/tool/weldingtool/advanced
	name = "advanced welding tool"
	icon_state = "adv_welder"
	item_state = "adv_welder"
	glow_color = COLOR_BLUE_LIGHT
	switched_on_qualities = list(QUALITY_WELDING = 40, QUALITY_CAUTERIZING = 15, QUALITY_WIRE_CUTTING = 15)
	max_fuel = 40
	switched_on_force = WEAPON_FORCE_PAINFUL * 1.15 //Slightly more powerful, not much more so
	heat = 3773
	degradation = 0.7
	max_upgrades = 4

/obj/item/weapon/tool/weldingtool/onestar
	name = "One Star welding tool"
	desc = "An old and legendary One Star welding tool. Very powerful and reliable, but its compact design causes it to suffer from a lack of both fuel storage and efficiency."
	icon_state = "one_star_welder"
	item_state = "welder"
	matter = list(MATERIAL_STEEL = 4, MATERIAL_PLATINUM = 2)
	origin_tech = list(TECH_ENGINEERING = 2, TECH_MATERIAL = 3)
	switched_on_qualities = list(QUALITY_WELDING = 30, QUALITY_CAUTERIZING = 10, QUALITY_WIRE_CUTTING = 10)
	glow_color = COLOR_RED_LIGHT
	use_fuel_cost = 0.15
	max_fuel = 20
	degradation = 0.6
	heat = 2750
	max_upgrades = 2
	workspeed = 1.7
