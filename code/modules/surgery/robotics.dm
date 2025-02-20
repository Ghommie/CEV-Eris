//Procedures in this file: Gneric surgery steps
//////////////////////////////////////////////////////////////////
//						COMMON STEPS							//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/robotics
	can_infect = 0
/datum/surgery_step/robotics/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (isslime(target))
		return 0
	if (target_zone == BP_EYES)	//there are specific steps for eye surgery
		return 0
	if (!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (affected == null)
		return 0
	if (affected.status & ORGAN_DESTROYED)
		return 0
	if (!BP_IS_ROBOTIC(affected))
		return 0
	return 1

/datum/surgery_step/robotics/unscrew_hatch
	requedQuality = QUALITY_SCREW_DRIVING

	min_duration = 90
	max_duration = 110

/datum/surgery_step/robotics/unscrew_hatch/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && affected.open == 0 && target_zone != BP_MOUTH

/datum/surgery_step/robotics/unscrew_hatch/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts to unscrew the maintenance hatch on [target]'s [affected.name] with \the [tool].", \
	"You start to unscrew the maintenance hatch on [target]'s [affected.name] with \the [tool].")
	..()

/datum/surgery_step/robotics/unscrew_hatch/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_NOTICE("[user] has opened the maintenance hatch on [target]'s [affected.name] with \the [tool]."), \
	SPAN_NOTICE("You have opened the maintenance hatch on [target]'s [affected.name] with \the [tool]."),)
	affected.open = 1

/datum/surgery_step/robotics/unscrew_hatch/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s [tool.name] slips, failing to unscrew [target]'s [affected.name]."), \
	SPAN_WARNING("Your [tool] slips, failing to unscrew [target]'s [affected.name]."))

/datum/surgery_step/robotics/open_hatch
	requedQuality = QUALITY_PRYING

	min_duration = 30
	max_duration = 40

/datum/surgery_step/robotics/open_hatch/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && affected.open == 1

/datum/surgery_step/robotics/open_hatch/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts to pry open the maintenance hatch on [target]'s [affected.name] with \the [tool].",
	"You start to pry open the maintenance hatch on [target]'s [affected.name] with \the [tool].")
	..()

/datum/surgery_step/robotics/open_hatch/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_NOTICE("[user] opens the maintenance hatch on [target]'s [affected.name] with \the [tool]."), \
		SPAN_NOTICE("You open the maintenance hatch on [target]'s [affected.name] with \the [tool]."))
	affected.open = 2

/datum/surgery_step/robotics/open_hatch/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s [tool.name] slips, failing to open the hatch on [target]'s [affected.name]."),
	SPAN_WARNING("Your [tool] slips, failing to open the hatch on [target]'s [affected.name]."))

/datum/surgery_step/robotics/close_hatch
	requedQuality = QUALITY_PRYING

	min_duration = 70
	max_duration = 100

/datum/surgery_step/robotics/close_hatch/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && affected.open && target_zone != BP_MOUTH

/datum/surgery_step/robotics/close_hatch/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] begins to close and secure the hatch on [target]'s [affected.name] with \the [tool]." , \
	"You begin to close and secure the hatch on [target]'s [affected.name] with \the [tool].")
	..()

/datum/surgery_step/robotics/close_hatch/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_NOTICE("[user] closes and secures the hatch on [target]'s [affected.name] with \the [tool]."), \
	SPAN_NOTICE("You close and secure the hatch on [target]'s [affected.name] with \the [tool]."))
	affected.open = 0
	affected.germ_level = 0

/datum/surgery_step/robotics/close_hatch/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s [tool.name] slips, failing to close the hatch on [target]'s [affected.name]."),
	SPAN_WARNING("Your [tool.name] slips, failing to close the hatch on [target]'s [affected.name]."))

/datum/surgery_step/robotics/repair_brute
	requedQuality = QUALITY_WELDING

	min_duration = 50
	max_duration = 60

/datum/surgery_step/robotics/repair_brute/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		if(!istype(tool,/obj/item/weapon/tool/weldingtool))
			return 0
		return affected && affected.brute_dam > 0 && target_zone != BP_MOUTH

/datum/surgery_step/robotics/repair_brute/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] begins to patch damage to [target]'s [affected.name]'s support structure with \the [tool]." , \
	"You begin to patch damage to [target]'s [affected.name]'s support structure with \the [tool].")
	..()

/datum/surgery_step/robotics/repair_brute/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_NOTICE("[user] finishes patching damage to [target]'s [affected.name] with \the [tool]."), \
	SPAN_NOTICE("You finish patching damage to [target]'s [affected.name] with \the [tool]."))
	affected.heal_damage(rand(30,50),0,1,1)

/datum/surgery_step/robotics/repair_brute/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s [tool.name] slips, damaging the internal structure of [target]'s [affected.name]."),
	SPAN_WARNING("Your [tool.name] slips, damaging the internal structure of [target]'s [affected.name]."))
	target.apply_damage(rand(5,10), BURN, affected)

/datum/surgery_step/robotics/repair_burn
	allowed_tools = list(
		/obj/item/stack/cable_coil = 100
	)

	min_duration = 50
	max_duration = 60

/datum/surgery_step/robotics/repair_burn/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/stack/cable_coil/C = tool
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		var/limb_can_operate = (affected && affected.open == 2 && affected.burn_dam > 0 && target_zone != BP_MOUTH)
		if(limb_can_operate)
			if(istype(C))
				if(!C.get_amount() >= 3)
					user << SPAN_DANGER("You need three or more cable pieces to repair this damage.")
					return SURGERY_FAILURE
				C.use(3)
			return 1
		return 0

/datum/surgery_step/robotics/repair_burn/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] begins to splice new cabling into [target]'s [affected.name]." , \
	"You begin to splice new cabling into [target]'s [affected.name].")
	..()

/datum/surgery_step/robotics/repair_burn/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_NOTICE("[user] finishes splicing cable into [target]'s [affected.name]."), \
	SPAN_NOTICE("You finishes splicing new cable into [target]'s [affected.name]."))
	affected.heal_damage(0,rand(30,50),1,1)

/datum/surgery_step/robotics/repair_burn/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user] causes a short circuit in [target]'s [affected.name]!"),
	SPAN_WARNING("You cause a short circuit in [target]'s [affected.name]!"))
	target.apply_damage(rand(5,10), BURN, affected)

/datum/surgery_step/robotics/fix_organ_robotic //For artificial organs
	requedQuality = QUALITY_SCREW_DRIVING

	min_duration = 70
	max_duration = 90

/datum/surgery_step/robotics/fix_organ_robotic/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!affected) return
	var/is_organ_damaged = 0
	for(var/obj/item/organ/I in affected.internal_organs)
		if(I.damage > 0 && BP_IS_ROBOTIC(I))
			is_organ_damaged = 1
			break
	return affected.open == 2 && is_organ_damaged

/datum/surgery_step/robotics/fix_organ_robotic/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	for(var/obj/item/organ/I in affected.internal_organs)
		if(I && I.damage > 0)
			if(BP_IS_ROBOTIC(I))
				user.visible_message("[user] starts mending the damage to [target]'s [I.name]'s mechanisms.", \
				"You start mending the damage to [target]'s [I.name]'s mechanisms." )

	target.custom_pain("The pain in your [affected.name] is living hell!",1)
	..()

/datum/surgery_step/robotics/fix_organ_robotic/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	for(var/obj/item/organ/I in affected.internal_organs)

		if(I && I.damage > 0)
			if(BP_IS_ROBOTIC(I))
				user.visible_message(SPAN_NOTICE("[user] repairs [target]'s [I.name] with [tool]."), \
				SPAN_NOTICE("You repair [target]'s [I.name] with [tool].") )
				I.damage = 0

/datum/surgery_step/robotics/fix_organ_robotic/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	user.visible_message(SPAN_WARNING("[user]'s hand slips, gumming up the mechanisms inside of [target]'s [affected.name] with \the [tool]!"), \
	SPAN_WARNING("Your hand slips, gumming up the mechanisms inside of [target]'s [affected.name] with \the [tool]!"))

	target.adjustToxLoss(5)
	affected.createwound(CUT, 5)

	for(var/obj/item/organ/I in affected.internal_organs)
		if(I)
			I.take_damage(rand(3,5),0)

/datum/surgery_step/robotics/detatch_organ_robotic
	requedQuality = QUALITY_SAWING

	min_duration = 90
	max_duration = 110

/datum/surgery_step/robotics/detatch_organ_robotic/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!(affected && BP_IS_ROBOTIC(affected)))
		return 0
	if(affected.open != 2)
		return 0

	target.op_stage.current_organ = null

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
		return 0

	target.op_stage.current_organ = organ_to_remove

	return ..() && organ_to_remove

/datum/surgery_step/robotics/detatch_organ_robotic/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts to decouple [target]'s [target.op_stage.current_organ] with \the [tool].", \
	"You start to decouple [target]'s [target.op_stage.current_organ] with \the [tool]." )
	..()

/datum/surgery_step/robotics/detatch_organ_robotic/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(SPAN_NOTICE("[user] has decoupled [target]'s [target.op_stage.current_organ] with \the [tool].") , \
	SPAN_NOTICE("You have decoupled [target]'s [target.op_stage.current_organ] with \the [tool]."))

	var/obj/item/organ/I = target.internal_organs_by_name[target.op_stage.current_organ]
	if(I && istype(I))
		I.status |= ORGAN_CUT_AWAY

/datum/surgery_step/robotics/detatch_organ_robotic/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, disconnecting \the [tool]."), \
	SPAN_WARNING("Your hand slips, disconnecting \the [tool]."))

/datum/surgery_step/robotics/attach_organ_robotic
	requedQuality = QUALITY_SCREW_DRIVING

	min_duration = 100
	max_duration = 120

/datum/surgery_step/robotics/attach_organ_robotic/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!(affected && BP_IS_ROBOTIC(affected)))
		return 0
	if(affected.open != 2)
		return 0

	target.op_stage.current_organ = null

	var/list/removable_organs = list()
	for(var/organ in target.internal_organs_by_name)
		var/obj/item/organ/I = target.internal_organs_by_name[organ]
		if(I && (I.status & ORGAN_CUT_AWAY) && BP_IS_ROBOTIC(I) && I.parent_organ == target_zone)
			removable_organs |= organ

	var/organ_to_replace = input(user, "Which organ do you want to reattach?") as null|anything in removable_organs
	if(!organ_to_replace)
		return 0

	target.op_stage.current_organ = organ_to_replace
	return ..()

/datum/surgery_step/robotics/attach_organ_robotic/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] begins reattaching [target]'s [target.op_stage.current_organ] with \the [tool].", \
	"You start reattaching [target]'s [target.op_stage.current_organ] with \the [tool].")
	..()

/datum/surgery_step/robotics/attach_organ_robotic/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(SPAN_NOTICE("[user] has reattached [target]'s [target.op_stage.current_organ] with \the [tool].") , \
	SPAN_NOTICE("You have reattached [target]'s [target.op_stage.current_organ] with \the [tool]."))

	var/obj/item/organ/I = target.internal_organs_by_name[target.op_stage.current_organ]
	if(I && istype(I))
		I.status &= ~ORGAN_CUT_AWAY

/datum/surgery_step/robotics/attach_organ_robotic/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, disconnecting \the [tool]."), \
	SPAN_WARNING("Your hand slips, disconnecting \the [tool]."))

/datum/surgery_step/robotics/install_mmi
	allowed_tools = list(
	/obj/item/device/mmi = 100
	)

	min_duration = 60
	max_duration = 80

/datum/surgery_step/robotics/install_mmi/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

	if(target_zone != BP_HEAD)
		return

	var/obj/item/device/mmi/M = tool
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!(affected && affected.open == 2))
		return 0

	if(!istype(M))
		return 0

	if(!M.brainmob || !M.brainmob.client || !M.brainmob.ckey || M.brainmob.stat >= DEAD)
		user << SPAN_DANGER("That brain is not usable.")
		return SURGERY_FAILURE

	if(BP_IS_ORGANIC(affected) || BP_IS_ASSISTED(affected))
		user << SPAN_DANGER("You cannot install a computer brain into a meat skull.")
		return SURGERY_FAILURE

	if(!target.species)
		user << SPAN_DANGER("You have no idea what species this person is. Report this on the bug tracker.")
		return SURGERY_FAILURE

	if(!target.species.has_organ[BP_BRAIN])
		user << SPAN_DANGER("You're pretty sure [target.species.name_plural] don't normally have a brain.")
		return SURGERY_FAILURE

	if(!isnull(target.internal_organs[BP_BRAIN]))
		user << SPAN_DANGER("Your subject already has a brain.")
		return SURGERY_FAILURE

	return 1

/datum/surgery_step/robotics/install_mmi/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts installing \the [tool] into [target]'s [affected.name].", \
	"You start installing \the [tool] into [target]'s [affected.name].")
	..()

/datum/surgery_step/robotics/install_mmi/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_NOTICE("[user] has installed \the [tool] into [target]'s [affected.name]."), \
	SPAN_NOTICE("You have installed \the [tool] into [target]'s [affected.name]."))

	var/obj/item/device/mmi/M = tool
	var/obj/item/organ/mmi_holder/holder = new(target, 1)
	target.internal_organs_by_name[BP_BRAIN] = holder
	user.drop_from_inventory(tool)
	tool.loc = holder
	holder.stored_mmi = tool
	holder.update_from_mmi()

	if(M.brainmob && M.brainmob.mind)
		M.brainmob.mind.transfer_to(target)

/datum/surgery_step/robotics/install_mmi/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(SPAN_WARNING("[user]'s hand slips."), \
	SPAN_WARNING("Your hand slips."))
