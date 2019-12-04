/datum/symptom/lubefeet
	name = "Ducatopod"
	desc = "The host now sweats industrial lubricant from their feet, lubing tiles they walk on. Combine with Pierrot's throat for the penultimate form of torture."
	stealth = -4
	resistance = -2
	stage_speed = 4
	transmittable = 1
	level = 9
	severity = 3
	symptom_delay_min = 15
	symptom_delay_max = 30
	var/morelube = FALSE
	var/clownshoes = TRUE
	threshold_desc = "<b>Transmission 10:</b> The host sweats even more profusely, lubing almost every tile they walk over<br>\
					  <b>Resistance 12:</b> The host's feet turn into a pair of clown shoes."				

/datum/symptom/lubefeet/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.properties["transmission"] >= 10)
		morelube = TRUE
	if(A.properties["resistance"] >= 12)
		clownshoes = TRUE

/datum/symptom/lubefeet/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/M = A.affected_mob
	switch(A.stage)
		if(1, 2)
			if(prob(15))
				to_chat(M, "<span class='notice'>Your feet begin to sweat profusely...</span>")
		if(3, 4, 5)
			if(prob(10))
				to_chat(M, "<span class='danger'>You slip from the lube from your feet!</span>")
				M.slip()
			if(A.stage == 4 || A.stage == 5)
				if(morelube)
					makelube(M, 25)
				else
					makelube(M, 5)

/datum/symptom/lubefeet/proc/makelube(mob/living/carbon/M, chance)
	if(prob(chance))
		var/turf/open/OT = get_turf(M)
		if(istype(OT))
			to_chat(M, "<span class='danger'>The lube pools into a puddle!</span>")
			OT.MakeSlippery(TURF_WET_LUBE, min_wet_time = 20 SECONDS, wet_time_to_add = 10 SECONDS)

/datum/symptom/pierrot/End(datum/disease/advance/A)
	..()
	if(ishuman(A.affected_mob))
		var/mob/living/carbon/human/M = A.affected_mob
		if(istype(M.shoes, /obj/item/clothing/shoes/clown_shoes))
			REMOVE_TRAIT(M.shoes, TRAIT_NODROP, DISEASE_TRAIT)

/datum/symptom/lubefeet/proc/give_clown_shoes(datum/disease/advance/A)
	if(ishuman(A.affected_mob))
		var/mob/living/carbon/human/M = A.affected_mob 
		if(!istype(M.shoes, /obj/item/clothing/shoes/clown_shoes))
			if(!M.dropItemToGround(M.shoes))
				qdel(M.shoes)
		var/obj/item/clothing/C = new /obj/item/clothing/shoes/clown_shoes(M)
		ADD_TRAIT(C, TRAIT_NODROP, DISEASE_TRAIT)
		M.equip_to_slot_or_del(C, SLOT_SHOES)
		return		
