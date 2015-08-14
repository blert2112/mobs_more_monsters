
local ENABLE_SPAWN_NODE = true

-- sounds
local green_sounds = {
	damage = "slimes_damage",
	death = "slimes_death",
	jump = "slimes_jump",
	attack = "slimes_attack"
}

-- textures
local green_textures = {"green_slime_sides.png", "green_slime_sides.png", "green_slime_sides.png",
	"green_slime_sides.png", "green_slime_front.png", "green_slime_sides.png"}

-- small
mobs:register_mob("mobs_slimes:green_small", {
	type = "monster",
	visual = "cube",
	textures = { green_textures },
	visual_size = {x = 0.5, y = 0.5},
	collisionbox = {-0.25, -0.25, -0.25, 0.25, 0.25, 0.25},
	sounds = green_sounds,
	hp_min = 2,
	hp_max = 4,
	armor = 100,
	knock_back = 3,
	blood_amount = 3,
	blood_texture = "green_slime_blood.png",
	lava_damage = 3,
	fall_damage = 0,
	damage = 1,
	attack_type = "dogfight",
	attacks_monsters = true,
	view_range = 10,
	walk_chance = 0,
	walk_velocity = 2,
	stepheight = 0.6,
	jump_chance = 60,
	drops = {
		{name = "mobs_slimes:green_slimeball", chance = 2, min = 1, max = 2},
	}
})

-- medium
mobs:register_mob("mobs_slimes:green_medium", {
	type = "monster",
	visual = "cube",
	textures = { green_textures },
	visual_size = {x = 1, y = 1},
	collisionbox = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
	sounds = green_sounds,
	hp_min = 4,
	hp_max = 8,
	armor = 100,
	knock_back = 2,
	blood_amount = 4,
	blood_texture = "green_slime_blood.png",
	lava_damage = 7,
	fall_damage = 0,
	damage = 2,
	attack_type = "dogfight",
	attacks_monsters = true,
	view_range = 10,
	walk_chance = 0,
	walk_velocity = 2,
	stepheight = 1.1,
	jump_chance = 60,
	on_die = function(self, pos)
		local num = math.random(2, 4)
		for i=1,num do
			minetest.add_entity({x=pos.x + math.random(-2, 2), y=pos.y + 1, z=pos.z + (math.random(-2, 2))}, "mobs_slimes:green_small")
		end
	end
})

-- big
mobs:register_mob("mobs_slimes:green_big", {
	type = "monster",
	visual = "cube",
	textures = { green_textures },
	visual_size = {x = 2, y = 2},
	collisionbox = {-1, -1, -1, 1, 1, 1},
	sounds = green_sounds,
	hp_min = 6,
	hp_max = 12,
	armor = 100,
	knock_back = 1,
	blood_amount = 5,
	blood_texture = "green_slime_blood.png",
	lava_damage = 11,
	fall_damage = 0,
	damage = 3,
	attack_type = "dogfight",
	attacks_monsters = true,
	view_range = 10,
	walk_chance = 0,
	walk_velocity = 2,
	stepheight = 1.1,
	jump_chance = 60,
	on_die = function(self, pos)
		local num = math.random(1, 2)
		for i=1,num do
			minetest.add_entity({x=pos.x + math.random(-2, 2), y=pos.y + 1, z=pos.z + (math.random(-2, 2))}, "mobs_slimes:green_medium")
		end
	end
})

local l_spawn_elevation_min = minetest.setting_get("water_level")
if l_spawn_elevation_min then
	l_spawn_elevation_min = l_spawn_elevation_min - 1
else
	l_spawn_elevation_min = -1
end
--name, nodes, neighbors, min_light, max_light, interval, chance, active_object_count, min_height, max_height
mobs:spawn_specific("mobs_slimes:green_big",
	{"default:dirt_with_grass", "default:junglegrass", "default:mossycobble", "ethereal:green_dirt_top"},
	{"air"},
	4, 20, 30, 10000, 1, l_spawn_elevation_min, 31000
)
mobs:spawn_specific("mobs_slimes:green_medium",
	{"default:dirt_with_grass", "default:junglegrass", "default:mossycobble", "ethereal:green_dirt_top"},
	{"air"},
	4, 20, 30, 20000, 2, l_spawn_elevation_min, 31000
)
mobs:spawn_specific("mobs_slimes:green_small",
	{"default:dirt_with_grass", "default:junglegrass", "default:mossycobble", "ethereal:green_dirt_top"},
	{"air"},
	4, 20, 30, 30000, 3, l_spawn_elevation_min, 31000
)

mobs:register_egg("mobs_slimes:green_small", "Small Green Slime", "green_slime_front.png", 0)
mobs:register_egg("mobs_slimes:green_medium", "Medium Green Slime", "green_slime_front.png", 0)
mobs:register_egg("mobs_slimes:green_big", "Big Green Slime", "green_slime_front.png", 0)

-- crafts
minetest.register_craftitem("mobs_slimes:green_slimeball", {
	image = "jeija_glue.png",
	description="Green Slime Ball",
})

-- spawner block
if ENABLE_SPAWN_NODE then
	minetest.register_node("mobs_slimes:green_spawner", {
		description = "Green Slime Spawner",
		tiles = {"green_slime_front.png"},
		is_ground_content = false,
		groups = {cracky=3, stone=1, mob_spawner=1},
		sounds = default.node_sound_stone_defaults({
			dug = {name="slimes_death", gain=0.25}
		})
	})
	minetest.register_abm({
		nodenames = {"mobs_slimes:green_spawner"},
		interval = 60.0,
		chance = 1,
		action = function(pos, node, active_object_count, active_object_count_wider)
			local p = pos
			p.y = p.y + 1
			minetest.add_entity(p, "mobs_slimes:green_big")
		end
	})
end
