// Internal surgeries.
/datum/surgery_step/internal
	priority = 2
	can_infect = 1
	blood_level = 1

/datum/surgery_step/internal/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

	if (!hasorgans(target))
		return 0

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.open == (affected.encased ? 3 : 2)

//////////////////////////////////////////////////////////////////
//				CHEST INTERNAL ORGAN SURGERY					//
//////////////////////////////////////////////////////////////////
/datum/surgery_step/internal/fix_organ
	allowed_tools = list(
	/obj/item/stack/medical/advanced/bruise_pack= 100,\
	/obj/item/stack/medical/bruise_pack = 20,\
	/obj/item/stack/nanopaste = 100
	)

	min_duration = 70
	max_duration = 90

/datum/surgery_step/internal/fix_organ/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!affected)
		return
	var/is_organ_damaged = 0
	for(var/obj/item/organ/I in affected.internal_organs)
		if(I.damage > 0)
			is_organ_damaged = 1
			break
	return ..() && is_organ_damaged

/datum/surgery_step/internal/fix_organ/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/tool_name = "\the [tool]"
	if (istype(tool, /obj/item/stack/medical/advanced/bruise_pack))
		tool_name = "regenerative membrane"
	else if (istype(tool, /obj/item/stack/medical/bruise_pack))
		tool_name = "the bandaid"
	else if (istype(tool, /obj/item/stack/nanopaste))
		tool_name = "nanite swarm"

	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	for(var/obj/item/organ/I in affected.internal_organs)
		if (istype(tool, /obj/item/stack/medical/advanced/bruise_pack))
			if (I.damage > 0 && !BP_IS_ROBOTIC(I))
				user.visible_message("[user] starts treating damage to [target]'s [I.name] with [tool_name].", \
				"You start treating damage to [target]'s [I.name] with [tool_name]." )
		else if (istype(tool, /obj/item/stack/medical/bruise_pack))
			if (I.damage > 0 && !BP_IS_ROBOTIC(I))
				user.visible_message("[user] starts treating damage to [target]'s [I.name] with [tool_name].", \
				"You start treating damage to [target]'s [I.name] with [tool_name]." )
		else if (istype(tool, /obj/item/stack/nanopaste))
			if (I.damage > 0 && (BP_IS_ROBOTIC(I) || BP_IS_ASSISTED(I)))
				user.visible_message(SPAN_NOTICE("[user] treats damage to [target]'s [I.name] with [tool_name]."), \
				SPAN_NOTICE("You treat damage to [target]'s [I.name] with [tool_name].") )

	target.custom_pain("The pain in your [affected.name] is living hell!",1)
	..()

/datum/surgery_step/internal/fix_organ/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/tool_name = "\the [tool]"
	if (istype(tool, /obj/item/stack/medical/advanced/bruise_pack))
		tool_name = "regenerative membrane"
	if (istype(tool, /obj/item/stack/medical/bruise_pack))
		tool_name = "theif (istype(tool,  bandaid"
	if (istype(tool, /obj/item/stack/nanopaste))
		tool_name = "nanite swarm"

	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	for(var/obj/item/organ/I in affected.internal_organs)
		if (istype(tool, /obj/item/stack/medical/advanced/bruise_pack))
			if (I.damage > 0 && !BP_IS_ROBOTIC(I))
				user.visible_message(SPAN_NOTICE("[user] treats damage to [target]'s [I.name] with [tool_name]."), \
				SPAN_NOTICE("You treat damage to [target]'s [I.name] with [tool_name].") )
				I.damage = 0
		else if (istype(tool, /obj/item/stack/medical/advanced/bruise_pack))
			if (I.damage > 0 && !BP_IS_ROBOTIC(I))
				user.visible_message(SPAN_NOTICE("[user] treats damage to [target]'s [I.name] with [tool_name]."), \
				SPAN_NOTICE("You treat damage to [target]'s [I.name] with [tool_name].") )
				I.damage = 0
		else if (istype(tool, /obj/item/stack/nanopaste))
			if (I.damage > 0 && (BP_IS_ROBOTIC(I) || BP_IS_ASSISTED(I)))
				user.visible_message(SPAN_NOTICE("[user] treats damage to [target]'s [I.name] with [tool_name]."), \
				SPAN_NOTICE("You treat damage to [target]'s [I.name] with [tool_name].") )
				I.damage= 0

/datum/surgery_step/internal/fix_organ/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	user.visible_message(SPAN_WARNING("[user]'s hand slips, getting mess and tearing the inside of [target]'s [affected.name] with \the [tool]!"), \
	SPAN_WARNING("Your hand slips, getting mess and tearing the inside of [target]'s [affected.name] with \the [tool]!"))
	var/dam_amt = 2

	if (istype(tool, /obj/item/stack/medical/advanced/bruise_pack))
		target.adjustToxLoss(5)

	else if (istype(tool, /obj/item/stack/medical/bruise_pack))
		dam_amt = 5
		target.adjustToxLoss(10)
		affected.createwound(CUT, 5)

	for(var/obj/item/organ/I in affected.internal_organs)
		if(I && I.damage > 0)
			I.take_damage(dam_amt,0)

/datum/surgery_step/internal/detatch_organ

	requedQuality = QUALITY_CUTTING

	min_duration = 90
	max_duration = 110

/datum/surgery_step/internal/detatch_organ/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

	if (!..())
		return 0

	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	if(!(affected && !BP_IS_ROBOTIC(affected)))
		return 0

	target.op_stage.current_organ = null

	var/list/attached_organs = list()
	for(var/organ in target.internal_organs_by_name)
		var/obj/item/organ/I = target.internal_organs_by_name[organ]
		if(I && !(I.status & ORGAN_CUT_AWAY) && I.parent_organ == target_zone)
			attached_organs |= organ
	if(!attached_organs.len)
		return 0
	return ..()

/datum/surgery_step/internal/detatch_organ/prepare_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/list/attached_organs = list()
	for(var/organ in target.internal_organs_by_name)
		var/obj/item/organ/I = target.internal_organs_by_name[organ]
		if(I && !(I.status & ORGAN_CUT_AWAY) && I.parent_organ == target_zone)
			attached_organs |= organ
	var/list/options = list()
	for(var/i in attached_organs)
		var/obj/item/organ/I = target.internal_organs_by_name[i]
		options[i] = image(icon = I.icon, icon_state = I.icon_state)
	var/organ_to_remove
	organ_to_remove = show_radial_menu(user, target, options, radius = 32)
	if(!organ_to_remove)
		return FALSE

	target.op_stage.current_organ = organ_to_remove
	return TRUE

/datum/surgery_step/internal/detatch_organ/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	user.visible_message("[user] starts to separate [target]'s [target.op_stage.current_organ] with \the [tool].", \
	"You start to separate [target]'s [target.op_stage.current_organ] with \the [tool]." )
	target.custom_pain("The pain in your [affected.name] is living hell!",1)
	..()

/datum/surgery_step/internal/detatch_organ/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(SPAN_NOTICE("[user] has separated [target]'s [target.op_stage.current_organ] with \the [tool].") , \
	SPAN_NOTICE("You have separated [target]'s [target.op_stage.current_organ] with \the [tool]."))

	var/obj/item/organ/I = target.internal_organs_by_name[target.op_stage.current_organ]
	if(I && istype(I))
		I.status |= ORGAN_CUT_AWAY

/datum/surgery_step/internal/detatch_organ/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, slicing an artery inside [target]'s [affected.name] with \the [tool]!"), \
	SPAN_WARNING("Your hand slips, slicing an artery inside [target]'s [affected.name] with \the [tool]!"))
	affected.createwound(CUT, rand(30,50), 1)

/datum/surgery_step/internal/remove_organ
	requedQuality = QUALITY_CLAMPING

	min_duration = 60
	max_duration = 80

/datum/surgery_step/internal/remove_organ/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!..())
		return 0
	target.op_stage.current_organ = null
	var/list/removable_organs = list()
	for(var/organ in target.internal_organs_by_name)
		var/obj/item/organ/I = target.internal_organs_by_name[organ]
		if((I.status & ORGAN_CUT_AWAY) && I.parent_organ == target_zone)
			removable_organs |= organ
	if(!removable_organs.len)
		return 0
	return ..()


/datum/surgery_step/internal/remove_organ/prepare_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/list/attached_organs = list()
	for(var/organ in target.internal_organs_by_name)
		var/obj/item/organ/I = target.internal_organs_by_name[organ]
		if(I && I.status & ORGAN_CUT_AWAY && I.parent_organ == target_zone)
			attached_organs |= organ
	var/list/options = list()
	for(var/i in attached_organs)
		var/obj/item/organ/I = target.internal_organs_by_name[i]
		options[i] = image(icon = I.icon, icon_state = I.icon_state)
	var/organ_to_remove
	organ_to_remove = show_radial_menu(user, target, options, radius = 32)
	if(!organ_to_remove)
		return FALSE

	target.op_stage.current_organ = organ_to_remove
	return TRUE


/datum/surgery_step/internal/remove_organ/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts removing [target]'s [target.op_stage.current_organ] with \the [tool].", \
	"You start removing [target]'s [target.op_stage.current_organ] with \the [tool].")
	target.custom_pain("Someone's ripping out your [target.op_stage.current_organ]!",1)
	..()

/datum/surgery_step/internal/remove_organ/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(SPAN_NOTICE("[user] has removed [target]'s [target.op_stage.current_organ] with \the [tool]."), \
	SPAN_NOTICE("You have removed [target]'s [target.op_stage.current_organ] with \the [tool]."))

	// Extract the organ!
	if(target.op_stage.current_organ)
		var/obj/item/organ/O = target.internal_organs_by_name[target.op_stage.current_organ]
		if(O && istype(O))
			O.removed(user)
		target.op_stage.current_organ = null
		playsound(target.loc, 'sound/effects/squelch1.ogg', 50, 1)

/datum/surgery_step/internal/remove_organ/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, damaging [target]'s [affected.name] with \the [tool]!"), \
	SPAN_WARNING("Your hand slips, damaging [target]'s [affected.name] with \the [tool]!"))
	affected.createwound(BRUISE, 20)

/datum/surgery_step/internal/replace_organ
	allowed_tools = list(
	/obj/item/organ = 100
	)

	min_duration = 60
	max_duration = 80

/datum/surgery_step/internal/replace_organ/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

	var/obj/item/organ/O = tool
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!affected) return
	var/organ_compatible
	var/organ_missing

	if(!istype(O))
		return 0

	if(BP_IS_ROBOTIC(affected) && !BP_IS_ROBOTIC(O))
		user << SPAN_DANGER("You cannot install a naked organ into a robotic body.")
		return SURGERY_FAILURE

	if(!target.species)
		user << SPAN_DANGER("You have no idea what species this person is. Report this on the bug tracker.")
		return SURGERY_FAILURE

	var/o_is = (O.gender == PLURAL) ? "are" : "is"
	var/o_a =  (O.gender == PLURAL) ? "" : "a "
	var/o_do = (O.gender == PLURAL) ? "don't" : "doesn't"

	if(target.species.has_organ[O.organ_tag])
		if(O.damage > (O.max_damage * 0.75))
			user << SPAN_WARNING("\The [O.organ_tag] [o_is] in no state to be transplanted.")
			return SURGERY_FAILURE

		if(!target.internal_organs_by_name[O.organ_tag])
			organ_missing = 1
		else
			user << SPAN_WARNING("\The [target] already has [o_a][O.organ_tag].")
			return SURGERY_FAILURE

		if(O && affected.organ_tag == O.parent_organ)
			organ_compatible = 1
		else
			user << SPAN_WARNING("\The [O.organ_tag] [o_do] normally go in \the [affected.name].")
			return SURGERY_FAILURE
	else
		user << SPAN_WARNING("You're pretty sure [target.species.name_plural] don't normally have [o_a][O.organ_tag].")
		return SURGERY_FAILURE

	return ..() && organ_missing && organ_compatible

/datum/surgery_step/internal/replace_organ/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts transplanting \the [tool] into [target]'s [affected.name].", \
	"You start transplanting \the [tool] into [target]'s [affected.name].")
	target.custom_pain("Someone's rooting around in your [affected.name]!",1)
	..()

/datum/surgery_step/internal/replace_organ/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_NOTICE("[user] has transplanted \the [tool] into [target]'s [affected.name]."), \
	SPAN_NOTICE("You have transplanted \the [tool] into [target]'s [affected.name]."))
	var/obj/item/organ/O = tool
	if(istype(O))
		user.remove_from_mob(O)
		O.replaced(target,affected)
		playsound(target.loc, 'sound/effects/squelch1.ogg', 50, 1)

/datum/surgery_step/internal/replace_organ/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, damaging \the [tool]!"), \
	SPAN_WARNING("Your hand slips, damaging \the [tool]!"))
	var/obj/item/organ/I = tool
	if(istype(I))
		I.take_damage(rand(3,5),0)

/datum/surgery_step/internal/attach_organ
	requedQuality = QUALITY_CAUTERIZING

	min_duration = 100
	max_duration = 120

/datum/surgery_step/internal/attach_organ/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

	if (!..())
		return 0

	target.op_stage.current_organ = null

	var/list/removable_organs = list()
	for(var/organ in target.internal_organs_by_name)
		var/obj/item/organ/I = target.internal_organs_by_name[organ]
		if(I && (I.status & ORGAN_CUT_AWAY) && !BP_IS_ROBOTIC(I) && I.parent_organ == target_zone)
			removable_organs |= organ

	if(!removable_organs.len)
		return 0

	return ..()

/datum/surgery_step/internal/attach_organ/prepare_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/list/removable_organs = list()
	for(var/organ in target.internal_organs_by_name)
		var/obj/item/organ/I = target.internal_organs_by_name[organ]
		if(I && (I.status & ORGAN_CUT_AWAY) && !BP_IS_ROBOTIC(I) && I.parent_organ == target_zone)
			removable_organs |= organ

	var/organ_to_replace = input(user, "Which organ do you want to reattach?") as null|anything in removable_organs
	if(!organ_to_replace)
		return FALSE

	target.op_stage.current_organ = organ_to_replace
	return TRUE

/datum/surgery_step/internal/attach_organ/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] begins reattaching [target]'s [target.op_stage.current_organ] with \the [tool].", \
	"You start reattaching [target]'s [target.op_stage.current_organ] with \the [tool].")
	target.custom_pain("Someone's digging needles into your [target.op_stage.current_organ]!",1)
	..()

/datum/surgery_step/internal/attach_organ/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(SPAN_NOTICE("[user] has reattached [target]'s [target.op_stage.current_organ] with \the [tool].") , \
	SPAN_NOTICE("You have reattached [target]'s [target.op_stage.current_organ] with \the [tool]."))

	var/obj/item/organ/I = target.internal_organs_by_name[target.op_stage.current_organ]
	if(I && istype(I))
		I.status &= ~ORGAN_CUT_AWAY

/datum/surgery_step/internal/attach_organ/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, damaging the flesh in [target]'s [affected.name] with \the [tool]!"), \
	SPAN_WARNING("Your hand slips, damaging the flesh in [target]'s [affected.name] with \the [tool]!"))
	affected.createwound(BRUISE, 20)

//////////////////////////////////////////////////////////////////
//						HEART SURGERY							//
//////////////////////////////////////////////////////////////////
// To be finished after some tests.
// /datum/surgery_step/ribcage/heart/cut
//	allowed_tools = list(
//	/obj/item/weapon/tool/scalpel = 100,		\
//	/obj/item/weapon/material/knife = 75,	\
//	/obj/item/weapon/material/shard = 50, 		\
//	)

//	min_duration = 30
//	max_duration = 40

//	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
//		return ..() && target.op_stage.ribcage == 2
