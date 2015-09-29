
if mobs.mod and mobs.mod == "redo" then

	local ENABLE_SPAWN_NODE = true
	local ENABLE_PUMPKIN_BOOM = true
	
	mobs:register_mob("mobs_pumpking:pumpking", {
		type = "monster",
		visual = "mesh",
		mesh = "pumpking.x",
		textures = {
			{"pumpking.png"}
		},
		visual_size = {x=3, y=3},
		collisionbox = {-0.85, 0.00, -0.85, 0.85, 5.3, 0.85},
		animation = {
			speed_normal = 15,	speed_run = 30,
			stand_start = 165,	stand_end = 210,
			walk_start = 61,	walk_end = 110,	
			run_start = 0,		run_end = 50,
			punch_start = 150,	punch_end = 165
		},
		makes_footstep_sound = true,
		sounds = {
			random = "king"
		},
		hp_min = 85,
		hp_max = 90,
		armor = 30,
		knock_back = 1,
		light_damage = 10,
		water_damage = 5,
		lava_damage = 5,
		fall_damage = 20,
		damage = 10,
		reach = 3,
		attack_type = "dogfight",
		view_range = 25,
		stepheight = 1.1,
		drops = {
			{name = "farming:jackolantern", chance = 1, min = 1, max = 1}
		},
		lifetimer = 180,		-- 3 minutes
		shoot_interval = 135,	-- (lifetimer - (lifetimer / 4)), borrowed for do_custom timer
		do_custom = function(self)
			if ENABLE_PUMPKIN_BOOM and self.lifetimer <= self.shoot_interval then
				p = self.object:getpos()
				p.y = p.y + 1
				minetest.add_entity(p, "mobs_pumpking:pumpboom")
				minetest.after(5.0, function(pos, str) minetest.add_entity(pos, str) end,
					p, "mobs_pumpking:pumpboom")
				self.shoot_interval = self.shoot_interval - 45
			end
		end
	})

	local l_spawn_elevation_min = minetest.setting_get("water_level")
	if l_spawn_elevation_min then
		l_spawn_elevation_min = l_spawn_elevation_min + 2
	else
		l_spawn_elevation_min = 2
	end
	--name, nodes, neighbors, min_light, max_light, interval, chance, active_object_count, min_height, max_height
	mobs:spawn_specific("mobs_pumpking:pumpking",
		{"default:dirt_with_grass", "default:dirt"},
		{"air"},
		-1, 6, 30, 100000, 1, l_spawn_elevation_min, 31000
	)
	mobs:register_egg("mobs_pumpking:pumpking", "Pumpkin King", "pumpking.png", 1)

	if ENABLE_PUMPKIN_BOOM then
		mobs:register_mob("mobs_pumpking:pumpboom", {
			type = "monster",
			visual = "mesh",
			mesh = "pumpboom.x",
			textures = {
				{"pumpboom.png"}
			},
			visual_size = {x=3, y=3},
			collisionbox = {-0.80, -0.3, -0.80, 0.80, 0.80, 0.80},
			rotate = 270,
			animation = {
				speed_normal = 15,	speed_run = 30,
				stand_start = 0,	stand_end = 30,
				walk_start = 81,	walk_end = 97,	
				run_start = 81,		run_end = 97,
				punch_start = 100,	punch_end = 120
			},
			sounds = {
				random = "pump"
			},
			hp_min = 2,
			hp_max = 5,
			armor = 200,
			light_damage = 2,
			water_damage = 2,
			lava_damage = 2,
			fall_damage = 3,
			damage = 4,
			reach = 2,
			attack_type = "explode",
			group_attack = true,
			view_range = 15,
			walk_velocity = 2,
			run_velocity = 4,
			drops = {
				{name = "farming:pumpkin_seed", chance = 1, min = 1, max = 4}
			}
		})
	end

-- spawner block
	if ENABLE_SPAWN_NODE then
		minetest.register_node("mobs_pumpking:pumpking_spawner", {
			description = "Pumpkin King Spawner",
			tiles = {"pumpboom.png"},
			is_ground_content = false,
			groups = {cracky=3, stone=1, mob_spawner=1},
			sounds = default.node_sound_stone_defaults({
				dug = {name="king", gain=0.25}
			})
		})
		minetest.register_abm({
			nodenames = {"mobs_pumpking:pumpking_spawner"},
			interval = 180.0,
			chance = 1,
			action = function(pos, node, active_object_count, active_object_count_wider)
				minetest.add_entity(pos, "mobs_pumpking:pumpking")
			end
		})
	end

end
