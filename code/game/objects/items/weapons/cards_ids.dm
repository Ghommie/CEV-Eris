/* Cards
 * Contains:
 *		DATA CARD
 *		ID CARD
 *		FINGERPRINT CARD HOLDER
 *		FINGERPRINT CARD
 */



/*
 * DATA CARDS - Used for the teleporter
 */
/obj/item/weapon/card
	name = "card"
	desc = "Does card things."
	icon = 'icons/obj/card.dmi'
	w_class = ITEM_SIZE_TINY

	var/list/files = list(  )

/obj/item/weapon/card/data
	name = "data disk"
	desc = "A disk of data."
	icon_state = "data"
	var/function = "storage"
	var/data = "null"
	var/special = null
	item_state = "card-id"

/obj/item/weapon/card/data/verb/label(t as text)
	set name = "Label Disk"
	set category = "Object"
	set src in usr

	if (t)
		src.name = text("data disk- '[]'", t)
	else
		src.name = "data disk"
	src.add_fingerprint(usr)
	return

/obj/item/weapon/card/data/clown
	name = "\proper the coordinates to clown planet"
	icon_state = "data"
	item_state = "card-id"
	layer = 3
	level = ABOVE_PLATING_LEVEL
	desc = "This card contains coordinates to the fabled Clown Planet. Handle with care."
	function = "teleporter"
	data = "Clown Land"

/*
 * ID CARDS
 */

/obj/item/weapon/card/emag_broken
	desc = "It's a card with a magnetic strip attached to some circuitry. It looks too busted to be used for anything but salvage."
	name = "broken cryptographic sequencer"
	icon_state = "emag"
	item_state = "card-id"
	origin_tech = list(TECH_MAGNET = 2, TECH_ILLEGAL = 2)

/obj/item/weapon/card/emag
	desc = "It's a card with a magnetic strip attached to some circuitry."
	name = "cryptographic sequencer"
	icon_state = "emag"
	item_state = "card-id"
	origin_tech = list(TECH_MAGNET = 2, TECH_ILLEGAL = 2)
	var/uses = 10

var/const/NO_EMAG_ACT = -50
/obj/item/weapon/card/emag/resolve_attackby(atom/A, mob/user)
	var/used_uses = A.emag_act(uses, user, src)
	if(used_uses == NO_EMAG_ACT)
		return ..(A, user)

	uses -= used_uses
	A.add_fingerprint(user)
	if(used_uses)
		log_and_message_admins("emagged \an [A].")

	if(uses<1)
		user.visible_message(SPAN_WARNING("\The [src] fizzles and sparks - it seems it's been used once too often, and is now spent."))
		user.drop_item()
		var/obj/item/weapon/card/emag_broken/junk = new(user.loc)
		junk.add_fingerprint(user)
		qdel(src)

	return 1

/obj/item/weapon/card/id
	name = "identification card"
	desc = "A card used to provide ID and determine access across the ship."
	icon_state = "id"
	item_state = "card-id"
	slot_flags = SLOT_ID

	var/access = list()
	var/registered_name = "Unknown" // The name registered_name on the card
	var/list/associated_email_login = list("login" = "", "password" = "")
	var/associated_account_number = 0

	var/age = "\[UNSET\]"
	var/blood_type = "\[UNSET\]"
	var/dna_hash = "\[UNSET\]"
	var/fingerprint_hash = "\[UNSET\]"
	var/sex = "\[UNSET\]"
	var/icon/front
	var/icon/side

	//alt titles are handled a bit weirdly in order to unobtrusively integrate into existing ID system
	var/assignment = null	//can be alt title or the actual job
	var/rank = null			//actual job
	var/dorm = 0			// determines if this ID has claimed a dorm already

	var/formal_name_prefix
	var/formal_name_suffix

/obj/item/weapon/card/id/examine(mob/user)
	set src in oview(1)
	if(in_range(usr, src))
		show(usr)
		usr << desc
	else
		usr << SPAN_WARNING("It is too far away.")

/obj/item/weapon/card/id/proc/prevent_tracking()
	return 0

/obj/item/weapon/card/id/proc/show(mob/user as mob)
	if(front && side)
		user << browse_rsc(front, "front.png")
		user << browse_rsc(side, "side.png")
	var/datum/browser/popup = new(user, "idcard", name, 600, 250)
	popup.set_content(dat())
	popup.set_title_image(usr.browse_rsc_icon(src.icon, src.icon_state))
	popup.open()
	return

/obj/item/weapon/card/id/proc/update_name()
	name = "[src.registered_name]'s ID Card ([src.assignment])"

/obj/item/weapon/card/id/proc/set_id_photo(var/mob/M)
	front = getFlatIcon(M, SOUTH, always_use_defdir = 1)
	side = getFlatIcon(M, WEST, always_use_defdir = 1)

/mob/proc/set_id_info(var/obj/item/weapon/card/id/id_card)
	id_card.age = 0
	id_card.registered_name		= real_name
	id_card.sex 				= capitalize(gender)
	id_card.set_id_photo(src)

	if(dna)
		id_card.blood_type		= dna.b_type
		id_card.dna_hash		= dna.unique_enzymes
		id_card.fingerprint_hash= md5(dna.uni_identity)
	id_card.update_name()

/mob/living/carbon/human/set_id_info(var/obj/item/weapon/card/id/id_card)
	..()
	id_card.age = age

/obj/item/weapon/card/id/proc/dat()
	var/dat = ("<table><tr><td>")
	dat += text("Name: []</A><BR>", registered_name)
	dat += text("Sex: []</A><BR>\n", sex)
	dat += text("Age: []</A><BR>\n", age)
	dat += text("Rank: []</A><BR>\n", assignment)
	dat += text("Fingerprint: []</A><BR>\n", fingerprint_hash)
	dat += text("Blood Type: []<BR>\n", blood_type)
	dat += text("DNA Hash: []<BR><BR>\n", dna_hash)
	if(front && side)
		dat +="<td align = center valign = top>Photo:<br><img src=front.png height=80 width=80 border=4><img src=side.png height=80 width=80 border=4></td>"
	dat += "</tr></table>"
	return dat

/obj/item/weapon/card/id/attack_self(mob/user as mob)
	user.visible_message("\The [user] shows you: \icon[src] [src.name]. The assignment on the card: [src.assignment]",\
		"You flash your ID card: \icon[src] [src.name]. The assignment on the card: [src.assignment]")

	src.add_fingerprint(user)
	return

/obj/item/weapon/card/id/GetAccess()
	return access

/obj/item/weapon/card/id/GetIdCard()
	return src
	
/obj/item/weapon/card/id/verb/read()
	set name = "Read ID Card"
	set category = "Object"
	set src in usr

	usr << text("\icon[] []: The current assignment on the card is [].", src, src.name, src.assignment)
	usr << "The blood type on the card is [blood_type]."
	usr << "The DNA hash on the card is [dna_hash]."
	usr << "The fingerprint hash on the card is [fingerprint_hash]."
	return


/obj/item/weapon/card/id/syndicate_command
	name = "syndicate ID card"
	desc = "An ID straight from the Syndicate."
	registered_name = "Syndicate"
	assignment = "Syndicate Overlord"
	access = list(access_syndicate, access_external_airlocks)

/obj/item/weapon/card/id/captains_spare
	name = "captain's spare ID"
	desc = "The spare ID of the High Lord himself."
	icon_state = MATERIAL_GOLD
	item_state = "gold_id"
	registered_name = "Captain"
	assignment = "Captain"

/obj/item/weapon/card/id/captains_spare/New()
	access = get_all_station_access()
	..()

/obj/item/weapon/card/id/synthetic
	name = "\improper Synthetic ID"
	desc = "Access module for NanoTrasen Synthetics"
	icon_state = "id-robot"
	item_state = "tdgreen"
	assignment = "Synthetic"

/obj/item/weapon/card/id/synthetic/New()
	access = get_all_station_access() + access_synth
	..()

/obj/item/weapon/card/id/all_access
	name = "\improper Administrator's spare ID"
	desc = "The spare ID of the Lord of Lords himself."
	icon_state = "data"
	item_state = "tdgreen"
	registered_name = "Administrator"
	assignment = "Administrator"
/obj/item/weapon/card/id/all_access/New()
	access = get_access_ids()
	..()

/obj/item/weapon/card/id/centcom
	name = "\improper CentCom. ID"
	desc = "An ID straight from Cent. Com."
	icon_state = "centcom"
	registered_name = "Central Command"
	assignment = "General"
	New()
		access = get_all_centcom_access()
		..()

/obj/item/weapon/card/id/gold
	icon_state = MATERIAL_GOLD
	item_state = "gold_id"

/obj/item/weapon/card/id/sci
	icon_state = "id_sci"

/obj/item/weapon/card/id/gene
	icon_state = "id_gene"

/obj/item/weapon/card/id/chem
	icon_state = "id_chem"

/obj/item/weapon/card/id/med
	icon_state = "id_med"

/obj/item/weapon/card/id/sci
	icon_state = "id_sci"

/obj/item/weapon/card/id/viro
	icon_state = "id_viro"

/obj/item/weapon/card/id/heatlab
	icon_state = "id_heatlab"

/obj/item/weapon/card/id/rd
	icon_state = "id_rd"

/obj/item/weapon/card/id/cmo
	icon_state = "id_cmo"

/obj/item/weapon/card/id/det
	icon_state = "id_inspector"

/obj/item/weapon/card/id/medcpec
	icon_state = "id_medspec"

/obj/item/weapon/card/id/sec
	icon_state = "id_operative"

/obj/item/weapon/card/id/hos
	icon_state = "id_hos"

/obj/item/weapon/card/id/hop
	icon_state = "id_hop"

/obj/item/weapon/card/id/ce
	icon_state = "id_ce"

/obj/item/weapon/card/id/engie
	icon_state = "id_engie"

/obj/item/weapon/card/id/atmos
	icon_state = "id_atmos"

/obj/item/weapon/card/id/car
	icon_state = "id_car"

/obj/item/weapon/card/id/hydro
	icon_state = "id_hydro"

/obj/item/weapon/card/id/chaplain
	icon_state = "id_chaplain"

/obj/item/weapon/card/id/black
	icon_state = "id_black"

/obj/item/weapon/card/id/dkgrey
	icon_state = "id_dkgrey"

/obj/item/weapon/card/id/ltgrey
	icon_state = "id_ltgrey"

/obj/item/weapon/card/id/white
	icon_state = "id_white"

/obj/item/weapon/card/id/blankwhite
	icon_state = "id_blankwhite"