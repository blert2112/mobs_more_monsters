
-- sounds
local lava_sounds = {
	damage = "slimes_damage",
	death = "slimes_death",
	jump = "slimes_jump",
	attack = "slimes_attack",
}

-- textures
local lava_textures = {"lava_slime_sides.png", "lava_slime_sides.png", "lava_slime_sides.png",
	"lava_slime_sides.png", "lava_slime_front.png", "lava_slime_sides.png"}

-- small
mobs:register_mob("mobs_slimes:lava_small", {
	type = "monster",
	visual = "cube",
	textures = { lava_textures },
	visual_size = {x = 0.5, y = 0.5},
	collisionbox = {-0.25, -0.25, -0.25, 0.25, 0.25, 0.25},
	sounds = lava_sounds,
	hp_min = 2,
	hp_max = 4,
	armor = 100,
	knock_back = 3,
	blood_amount = 3,
	blood_texture = "lava_slime_blood.png",
	water_damage = 3,
	fall_damage = 0,
	damage = 1,
	reach = 1,
	attack_type = "dogfight",
	attacks_monsters = true,
	view_range = 10,
	walk_chance = 0,
	walk_velocity = 2,
	stepheight = 0.6,
	jump_chance = 60,
	drops = {
		{name = "mobs_slimes:lava_slime", chance = 2, min = 1, max = 2},
	},
	replace_rate = 20,
	replace_what = {"air"},
	replace_with = "fire:basic_flame"
})

-- medium
mobs:register_mob("mobs_slimes:lava_medium", {
	type = "monster",
	visual = "cube",
	textures = { lava_textures },
	visual_size = {x = 1, y = 1},
	collisionbox = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
	sounds = lava_sounds,
	hp_min = 4,
	hp_max = 8,
	armor = 100,
	knock_back = 2,
	blood_amount = 4,
	blood_texture = "lava_slime_blood.png",
	water_damage = 7,
	fall_damage = 0,
	damage = 2,
	reach = 2,
	attack_type = "dogfight",
	attacks_monsters = true,
	view_range = 10,
	walk_chance = 0,
	walk_velocity = 2,
	stepheight = 1.1,
	jump_chance = 60,
	replace_rate = 20,
	replace_what = {"air"},
	replace_with = "fire:basic_flame",
	on_die = function(self, pos)
		local num = math.random(2, 4)
		for i=1,num do
			minetest.add_entity({x=pos.x + math.random(-2, 2), y=pos.y + 1, z=pos.z + (math.random(-2, 2))}, "mobs_slimes:lava_small")
		end
	end
})

-- register big lava slime
mobs:register_mob("mobs_slimes:lava_big", {
	type = "monster",
	visual = "cube",
	textures = { lava_textures },
	visual_size = {x = 2, y = 2},
	collisionbox = {-1, -1, -1, 1, 1, 1},
	sounds = lava_sounds,
	hp_min = 6,
	hp_max = 12,
	armor = 100,
	knock_back = 1,
	blood_amount = 5,
	blood_texture = "lava_slime_blood.png",
	water_damage = 11,
	fall_damage = 0,
	damage = 3,
	reach = 3,
	attack_type = "dogfight",
	attacks_monsters = true,
	view_range = 10,
	walk_chance = 0,
	walk_velocity = 2,
	stepheight = 1.1,
	jump_chance = 60,
	replace_rate = 20,
	replace_what = {"air"},
	replace_with = "fire:basic_flame",
	on_die = function(self, pos)
		local num = math.random(1, 2)
		for i=1,num do
			minetest.add_entity({x=pos.x + math.random(-2, 2), y=pos.y + 1, z=pos.z + (math.random(-2, 2))}, "mobs_slimes:lava_medium")
		end
	end
})

local l_spawn_elevation_max = minetest.setting_get("water_level")
if l_spawn_elevation_max then
	l_spawn_elevation_max = l_spawn_elevation_max - 64
else
	l_spawn_elevation_max = -64
end
--name, nodes, neighbors, min_light, max_light, interval, chance, active_object_count, min_height, max_height
mobs:spawn_specific("mobs_slimes:lava_big",
	{"default:lava_source"},
	{"default:lava_flowing"},
	4, 20, 30, 10000, 1, -31000, l_spawn_elevation_max
)
mobs:spawn_specific("mobs_slimes:lava_medium",
	{"default:lava_source"},
	{"default:lava_flowing"},
	4, 20, 30, 10000, 2, -31000, l_spawn_elevation_max
)
mobs:spawn_specific("mobs_slimes:lava_small",
	{"default:lava_source"},
	{"default:lava_flowing"},
	4, 20, 30, 10000, 3, -31000, l_spawn_elevation_max
)

mobs:register_egg("mobs_slimes:lava_small", "Small Lava Slime", "lava_slime_front.png", 0)
mobs:register_egg("mobs_slimes:lava_medium", "Medium Lava Slime", "lava_slime_front.png", 0)
mobs:register_egg("mobs_slimes:lava_big", "Big Lava Slime", "lava_slime_front.png", 0)

-- crafts
minetest.register_craftitem("mobs_slimes:lava_slime", {
	image = "zmobs_lava_orb.png",
	description="Lava Slime Ball",
})
end
