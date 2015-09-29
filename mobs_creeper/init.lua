
if mobs.mod and mobs.mod == "redo" then

	local ENABLE_SPAWN_NODE = true

-- creeper
	mobs:register_mob("mobs_creeper:creeper", {
		type = "monster",
		visual = "mesh",
		mesh = "mobs_tree_monster.x",
		textures = {
			{"mobs_creeper.png"},
		},
		visual_size = {x=4.5,y=4.5},
		collisionbox = {-0.4, -0.01, -0.4, 0.4, 1.9, 0.4},
		animation = {
			stand_start = 0,	stand_end = 24,
			walk_start = 25,	walk_end = 47,	
			run_start = 48,		run_end = 62,
			punch_start = 48,	punch_end = 62,
			speed_normal = 15,	speed_run = 15
		},
		makes_footstep_sound = true,
		sounds = {
			random = "mobs_treemonster",
			explode = "tnt_explode"
		},
		hp_min = 30,
		hp_max = 40,
		armor = 90,
		blood_texture = "mobs_creeper_inv.png",
		water_damage = 2,
		lava_damage = 15,
		damage = 21,
		reach = 2,
		attack_type = "explode",
		view_range = 16,
		run_velocity = 3,
		stepheight = 1.1,
		drops = {
			{name = "default:torch", chance = 10, min = 3, max = 5,},
			{name = "default:iron_lump", chance = 5, min = 1, max = 2,},
			{name = "default:coal_lump", chance = 3, min = 1, max = 3,}
		}
	})
	
	--name, nodes, neighbors, min_light, max_light, interval, chance, active_object_count, min_height, max_height
	mobs:spawn_specific("mobs_creeper:creeper",
		{"default:stone", "default:dirt_with_grass"},
		{"air"},
		-1, 20, 30, 20000, 1, -31000, 31000
	)
	mobs:register_egg("mobs_creeper:creeper", "Creeper", "mobs_creeper_inv.png", 1)

-- spawner block
	if ENABLE_SPAWN_NODE then
		minetest.register_node("mobs_creeper:creeper_spawner", {
			description = "Creeper Spawner",
			tiles = {"mobs_creeper_face.png"},
			is_ground_content = false,
			groups = {cracky=3, stone=1, mob_spawner=1},
			sounds = default.node_sound_stone_defaults({
				dug = {name="tnt_explode", gain=0.25}
			})
		})
		minetest.register_abm({
			nodenames = {"mobs_creeper:creeper_spawner"},
			interval = 60.0,
			chance = 1,
			action = function(pos, node, active_object_count, active_object_count_wider)
				minetest.add_entity(pos, "mobs_creeper:creeper")
			end
		})
	end
	
end