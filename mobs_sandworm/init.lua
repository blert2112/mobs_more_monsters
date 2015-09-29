
if mobs.mod and mobs.mod == "redo" then

	local ENABLE_SPAWN_NODE = true
	local spice_duration = 20.0		--seconds
	local spice_buff_speed = 1		--add to physics multiplier
	local spice_buff_jump = 0.5		--add to physics multiplier
	local spice_buff_gravity = 0.1	--subtract from physics multiplier

	mobs:register_mob("mobs_sandworm:sandworm", {
		type = "monster",
		visual = "mesh",
		mesh = "sandworm.x",
		textures = {
			{"sandworm.png"},
		},
		visual_size = {x=8, y=8},
		collisionbox = {-0.6, -0.2, -0.6, 0.6, 1.90, 0.6},
		animation = {
			speed_normal = 25,	speed_run = 40,
			stand_start = 0,	stand_end = 30,
			walk_start = 30,	walk_end = 70,
			run_start = 30,		run_end = 70,
			punch_start = 70,	punch_end = 90
		},
		sounds = {
			random = "sand"
		},
		hp_min = 40,
		hp_max = 50,
		armor = 50,
		knock_back = 0,
		light_damage = 0,
		water_damage = 5,
		lava_damage = 50,
		fall_damage = 0,
		damage = 10,
		reach = 2,
		attack_type = "dogfight",
		view_range = 10,
		walk_velocity = 2,
		stepheight = 1.1,
		drops = {
			{name = "mobs_sandworm:wormflesh_raw", chance = 2, min = 1, max = 5},
			{name = "mobs_sandworm:spice", chance = 2, min = 1, max = 1}
		}
	})

	--name, nodes, neighbors, min_light, max_light, interval, chance, active_object_count, min_height, max_height
	mobs:spawn_specific("mobs_sandworm:sandworm",
		{"default:sand", "default:desert_sand"},
		{"air"},
		-1, 18, 30, 500000, 1, -31000, 31000
	)
	mobs:register_egg("mobs_sandworm:sandworm", "Sand Worm", "worm_flesh.png", 1)

-- raw worm meat
	minetest.register_craftitem("mobs_sandworm:wormflesh_raw", {
		description = "Raw Worm Flesh",
		inventory_image = "worm_flesh.png",
		on_use = minetest.item_eat(1)
	})
-- cooked worm meat
	minetest.register_craftitem("mobs_sandworm:wormflesh", {
		description = "Roasted Worm Flesh",
		inventory_image = "roasted_worm_flesh.png",
		on_use = minetest.item_eat(2)
	})
	minetest.register_craft({
		type = "cooking",
		output = "mobs_sandworm:wormflesh",
		recipe = "mobs_sandworm:wormflesh_raw",
		cooktime = 4
	})
-- the spice ;) Dune tribute
	minetest.register_craftitem("mobs_sandworm:spice", {
		description = "The Spice Melange",
		inventory_image = "spice_bottle.png",
		on_use = function(itemstack, user, pointed_thing)
			if user:get_armor_groups().immortal then
				return
			end
			minetest.chat_send_player(user:get_player_name(), "I must not fear. Fear is the mind-killer. Fear is the little-death that brings total obliteration. I will face my fear. I will permit it to pass over me and through me. And when it has gone past I will turn the inner eye to see it's path. Where the fear has gone there will be nothing. Only I will remain.")
			itemstack:take_item(1)
			if minetest.get_modpath("vessels") then
				user:get_inventory():add_item("main", "vessels:glass_bottle")
			end
			user:set_hp(20)
			local armorgroups = user:get_armor_groups()
			user:set_armor_groups({immortal = 1})
			local physics = user:get_physics_override()
			user:set_physics_override({
				speed = physics.speed + spice_buff_speed,
				jump = physics.jump + spice_buff_jump,
				gravity = physics.gravity - spice_buff_gravity
			})
			minetest.after(spice_duration, function(armorgroups)
					user:set_armor_groups(armorgroups)
					local physics = user:get_physics_override()
					user:set_physics_override({
						speed = physics.speed - spice_buff_speed,
						jump = physics.jump - spice_buff_jump,
						gravity = physics.gravity + spice_buff_gravity
					})
				end, armorgroups)
		end
	})

-- spawner block
	if ENABLE_SPAWN_NODE then
		minetest.register_node("mobs_sandworm:sandworm_spawner", {
			description = "Sand Worm Spawner",
			tiles = {"sandworm.png"},
			is_ground_content = false,
			groups = {cracky=3, stone=1, mob_spawner=1},
			sounds = default.node_sound_stone_defaults({
				dug = {name="sand", gain=0.25}
			})
		})
		minetest.register_abm({
			nodenames = {"mobs_sandworm:sandworm_spawner"},
			interval = 180.0,
			chance = 1,
			action = function(pos, node, active_object_count, active_object_count_wider)
				minetest.add_entity(pos, "mobs_sandworm:sandworm")
			end
		})
	end

end
