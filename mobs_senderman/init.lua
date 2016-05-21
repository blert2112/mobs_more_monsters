
if mobs.mod and mobs.mod == "redo" then

	mobs:register_mob("mobs_senderman:senderman", {
		type = "monster",
		visual = "mesh",
		mesh = "sender_man.x",
		textures = {
			{"sender_man.png"}
		},
		visual_size = {x=6,y=6},
		collisionbox = {-0.5, -0.01, -0.5, 0.5, 5.4, 0.5},
		animation = {
			speed_normal = 15,	speed_run = 15,
			stand_start = 0,	stand_end = 14,
			walk_start = 15,	walk_end = 38,
			run_start = 40,		run_end = 63,
			punch_start = 40,	punch_end = 63
		},
		hp_min = 15,
		hp_max = 30,
		armor = 80,
		light_damage = 2,
		damage = 4,
		reach = 3,
		attack_type = "dogfight",
		view_range = 30,
		walk_velocity = 3,
		run_velocity = 6,
		stepheight = 1.1,
		drops = {
			{name = "default:nyancat", chance = 1, min = 1, max = 2,}
		}
	})

	local l_spawn_elevation_min = minetest.setting_get("water_level")
	if l_spawn_elevation_min then
		l_spawn_elevation_min = l_spawn_elevation_min + 3
	else
		l_spawn_elevation_min = 3
	end
	--name, nodes, neighbors, min_light, max_light, interval, chance, active_object_count, min_height, max_height
	mobs:spawn_specific("mobs_senderman:senderman",
		{"default:dirt_with_grass", "default:dirt", "default:desert_sand", "ethereal:green_dirt_top"},
		{"air"},
		-1, 3, 30, 20000, 1, l_spawn_elevation_min, 31000
	)
	mobs:register_egg("mobs_senderman:senderman", "Spawn Senderman", "senderman_egg.png", 0)

end
