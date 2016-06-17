/*
So I had to hack this in, sort of, to get shotguns working right.
Woo hoo.

Generic internal magazines
*/
/obj/item/ammo_magazine/shotgun/internal
	name = "Internal Shotgun Magazine"
	desc = "An internal magazine. It is not supposed to be seen or removed."
	icon_state = "shells"
	default_ammo = "/datum/ammo/bullet/shotgun"
	gun_type = "/obj/item/weapon/gun/shotgun" //Doesn't matter, it will never be ejected.
	max_rounds = 8
	handle_casing = EJECT_CASINGS

//-------------------------------------------------------
//Generic shotgun magazines. Only three of them, since all shotguns can use the same ammo unless we add other gauges.

/obj/item/ammo_magazine/shotgun
	name = "Box of Shotgun Slugs"
	desc = "A box filled with heavy shotgun shells. A timeless classic. 12 Gauge."
	icon_state = "shells"
	default_ammo = "/datum/ammo/bullet/shotgun"
	max_rounds = 10
	gun_type = "/obj/item/weapon/gun/shotgun"

/obj/item/ammo_magazine/shotgun/buckshot
	name = "Box of Buckshot Shells"
	desc = "A box filled with buckshot spread shotgun shells. 12 Gauge."
	icon_state = "beanbag"
	default_ammo = "/datum/ammo/bullet/shotgun/buckshot"
	max_rounds = 10

/obj/item/ammo_magazine/shotgun/incendiary
	name = "Box of Incendiary Slugs"
	desc = "A box filled with self-detonating incendiary shotgun rounds. 12 Gauge."
	icon_state = "incendiary"
	default_ammo = "/datum/ammo/bullet/shotgun/incendiary"
	max_rounds = 10

//-------------------------------------------------------

/obj/item/weapon/gun/shotgun
	w_class = 4
	mag_type = "/obj/item/ammo_magazine/shotgun"
	mag_type_internal = "/obj/item/ammo_magazine/shotgun/internal"
	recoil = 2
	force = 14.0
	twohanded = 1
	fire_sound = 'sound/weapons/shotgun.ogg'
	accuracy = 10
	slot_flags = SLOT_BACK
	reload_type = HANDFUL //All shotguns reload via handfuls.
	var/casing_types[] = list()// Our list of what to fire and when, refers to the ammo datum paths.

	New()
		..()
		casing_types = list() //We make a new list.
		var/i = current_mag.max_rounds //We pull the number of entries equal to the initial ammo count.
		for(i, i>casing_types.len, i--) //And we populate it with paths.
			casing_types += current_mag.default_ammo//For each individual shell.

/obj/item/weapon/gun/shotgun/merc
	name = "\improper Custom Built Shotgun"
	desc = "A cobbled-together pile of scrap and alien wood. Point end towards things you want to die. Has a burst fire feature, as if it needed it."
	icon_state = "rspshotgun"
	icon_empty = "rspshotgun0"
	item_state = "rspshotgun"
	fire_delay = 10
	muzzle_pixel_x = 31
	muzzle_pixel_y = 19
	rail_pixel_x = 10
	rail_pixel_y = 21
	under_pixel_x = 17
	under_pixel_y = 14
	burst_amount = 4
	burst_delay = 2
	accuracy = -10
	found_on_mercs = 1
	twohanded = 0

//-------------------------------------------------------

/obj/item/weapon/gun/shotgun/combat
	name = "\improper MK221 Tactical Shotgun"
	desc = "The Weyland-Yutani MK221 Shotgun, a semi-automatic shotgun with a quick fire rate."
	icon_state = "cshotgun"
	icon_empty = "cshotgun"
	item_state = "cshotgun"
	icon_wielded = "cshotgun-w"
	fire_delay = 12
	muzzle_pixel_x = 33
	muzzle_pixel_y = 19
	rail_pixel_x = 10
	rail_pixel_y = 21
	under_pixel_x = 14
	under_pixel_y = 16

	New()
		..()
		var/obj/item/attachable/grenade/G = new(src)
		G.can_be_removed = 0
		G.icon_state = "" //Gun already has a better one
		G.Attach(src)
		update_attachables()

//-------------------------------------------------------

/obj/item/ammo_magazine/shotgun/internal/double //For a double barrel.
	max_rounds = 2
	handle_casing = HOLD_CASINGS

/obj/item/weapon/gun/shotgun/double
	name = "\improper Double Barrel Shotgun"
	desc = "A double barreled shotgun of archaic, but sturdy design. Uses 12 Gauge Special slugs, but can only hold 2 at a time."
	icon_state = "dshotgun"
	icon_empty = "dshotgun"
	item_state = "dshotgun"
	icon_wielded = "dshotgun-w"
	mag_type = "/obj/item/ammo_magazine/shotgun/buckshot"
	mag_type_internal = "/obj/item/ammo_magazine/shotgun/internal/double"
	fire_delay = 6
	muzzle_pixel_x = 33
	muzzle_pixel_y = 21
	rail_pixel_x = 15
	rail_pixel_y = 22
	under_pixel_x = 21
	under_pixel_y = 16
	found_on_mercs = 1

/obj/item/weapon/gun/shotgun/double/sawn
	name = "\improper Sawn-Off Shotgun"
	desc = "A double barreled shotgun whose barrel has been artificially shortened to reduce range but increase damage and spread."
	icon_state = "sawnshotgun"
	icon_empty = "sawnshotgun"
	item_state = "sawnshotgun"
	fire_delay = 3
	muzzle_pixel_x = 30
	muzzle_pixel_y = 20
	rail_pixel_x = 11
	rail_pixel_y = 22
	under_pixel_x = 18
	under_pixel_y = 16
	accuracy = -20
	twohanded = 0
	dam_bonus = 15
	slot_flags = SLOT_BELT

//-------------------------------------------------------
//Shotguns in this category will need to be pumped each shot.

/obj/item/ammo_magazine/shotgun/internal/pump //The only cycle method.
	handle_casing = CYCLE_CASINGS

/obj/item/weapon/gun/shotgun/pump
	name = "\improper M37A2 Pump Shotgun"
	desc = "An Armat Battlefield Systems classic design, the M37A2 combines close-range firepower with long term reliability. Alt click or use the weapon tab to pump it."
	icon_state = "m37"
	icon_empty = "m37_empty"
	icon_wielded = "m37-w"
	item_state = "m37"
	fire_delay = 26
	muzzle_pixel_x = 33
	muzzle_pixel_y = 18
	rail_pixel_x = 10
	rail_pixel_y = 21
	under_pixel_x = 20
	under_pixel_y = 14
	autoejector = 0 //Does not automatically eject "magazines".
	var/recentpump = 0
	var/is_pumped = 0
	var/is_reloading = 0

	load_into_chamber()
		if(is_pumped == 0)
			return 0
		..()
		is_pumped = 0
		return 1

	verb/pump_shotgun()
		set category = "Weapons"
		set name = "Pump Shotgun"
		set src in usr

		if(!ishuman(usr)) return //These checks are killing me.We REALLY need a standard sanity check.
		if(!usr.canmove || usr.stat || usr.restrained())
			usr << "Not right now."
			return

		pump(usr)

		return

	AltClick(var/mob/user)

		if(!ishuman(user)) return //These checks are killing me.
		if(!user.canmove || user.stat || user.restrained())
			user << "Not right now."
			return

		pump(user)
		return

	proc/pump(mob/living/carbon/human/M as mob)
		if(recentpump)	return

		if(is_pumped) //I might make it so you can keep pumping.
			M << "There's already a shell in the chamber, just shoot it."
			return

		if(M.get_active_hand() != src && !M.get_inactive_hand() != src)  //not holding it.
			M << "You have to be holding a shotgun!"
			return

		if(in_chamber) //We have a shell in the chamber. DEBUG THIS SHOULD NEVER HAPPEN
			del(in_chamber) // Delete whatever it is. It shouldn't be there.
			in_chamber = null // If we leave this as in_chamber, the gun won't fire again. Swell, huh?
			return

		if(!current_mag || !ammo)
			M << "There's nothing loaded!"
			recentpump = 0
			return

		playsound(M, 'sound/weapons/shotgunpump.ogg', 70, 1)
		make_casing(1) //Override so it makes a casing.

		//ready_bullet()
		is_pumped = 1
		recentpump = 1
		if(current_mag && current_mag.current_rounds <= 0) // We should have a mag, and if it's empty, change icon.
			current_mag.current_rounds = 0 // Just in case we somehow had negative rounds.
			update_icon()
		spawn(20)
			recentpump = 0
		return 1
/*
	proc/ready_bullet()	//Clone of load_into_chamber, only does it at a different time.
		var/obj/item/projectile/P = new(src) //New bullet!
		P.ammo = src.ammo
		P.name = P.ammo.name
		P.icon_state = P.ammo.icon_state //Make it look fancy.
		in_chamber = P
		P.damage = P.ammo.damage //For reverse lookups.
		P.damage_type = P.damage_type
		return 1
*/

/*
	snowflake_reload(var/obj/item/ammo_magazine/A)
		if(!istype(A) || !istype(current_mag) || !istype(A,current_mag.type) || A.default_ammo != current_mag.default_ammo)
			if(usr) usr << "The ammo types must be the same."
			return 0
		if(A.current_rounds == 0)
			if(usr) usr << "That [A] is empty."
			return 0

		if(current_mag.current_rounds >= current_mag.max_rounds)
			if(usr) usr << "It's already full."
			return 0

		if(is_reloading) return

		var/shells_to_load = current_mag.max_rounds - current_mag.current_rounds
		if(shells_to_load > current_mag.max_rounds) return 0
		var/turf/start_turf = get_turf(src.loc)
		//This is terrible. I am going to rewrite it.
		if(usr && istype(usr,/mob/living/carbon/human)) //<---- what? why? why does it matter if they're human??? ??????????
			var/mob/living/carbon/human/H = usr
			H.visible_message("\blue [H] begins hand-reloading reloading \the [src].","\blue You begin hand-reloading the [src].")
			for(var/i = 1 to shells_to_load)
				is_reloading = 1
				if(get_turf(src.loc) != start_turf) break//We moved
				if(!A || !current_mag || current_mag.loc != src || A.loc != H) break	 //We ejected the mag
				if(H.get_active_hand() != A) break //We put it in backpacks
				if(!H || H.stat || H.lying || H.buckled) break //We died
				playsound(H, 'sound/weapons/shotgun_shell_insert.ogg', 50, 1)
				if(A.current_rounds == -1) //Default for max ammo
					A.current_rounds = A.max_rounds - 1
				else A.current_rounds--
				current_mag.current_rounds++
				if(A.current_rounds == 0)
					A.update_icon()
					src.update_icon()
					if(usr) usr << "\blue The [A] is empty!"
					is_reloading = 0
					break
				sleep(4)

			spawn(4 * shells_to_load)
				is_reloading = 0

		return 1
*/
//-------------------------------------------------------

/obj/item/ammo_magazine/shotgun/internal/pump/CMB //The only cycle method.
	max_rounds = 4

/obj/item/weapon/gun/shotgun/pump/cmb
	name = "\improper HG 37-12 Pump Shotgun"
	desc = "A four-round pump action shotgun with internal tube magazine allowing for quick reloading and highly accurate fire. Used exclusively by Colonial Marshals."
	icon_state = "CMBshotgun"
	icon_empty = "CMBshotgun"
	item_state = "CMBshotgun"
	icon_wielded = "CMBshotgun-w"
	mag_type = "/obj/item/ammo_magazine/shotgun/incendiary"
	mag_type_internal = "/obj/item/ammo_magazine/shotgun/internal/pump/CMB"
	fire_delay = 16
	muzzle_pixel_x = 30
	muzzle_pixel_y = 20
	rail_pixel_x = 10
	rail_pixel_y = 23
	under_pixel_x = 19
	under_pixel_y = 17

//-------------------------------------------------------