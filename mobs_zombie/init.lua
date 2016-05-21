
if mobs.mod and mobs.mod == "redo" then

	local ENABLE_MINI_ZOMBIE = true

-- zombie
	mobs:register_mob("mobs_zombie:zombie", {
		type = "monster",
		visual = "mesh",
		mesh = "creatures_mob.x",
		textures = {
			{"mobs_zombie.png"},
		},
		collisionbox = {-0.25, -1, -0.3, 0.25, 0.75, 0.3},
		animation = {
			speed_normal = 10,		speed_run = 15,
			stand_start = 0,		stand_end = 79,
			walk_start = 168,		walk_end = 188,
			run_start = 168,		run_end = 188
		},
		makes_footstep_sound = true,
		sounds = {
			random = "mobs_zombie.1",
			war_cry = "mobs_zombie.3",
			attack = "mobs_zombie.2",
			damage = "mobs_zombie_hit",
			death = "mobs_zombie_death",
		},
		hp_min = 12,
		hp_max = 35,
		armor = 200,
		knock_back = 1,
		lava_damage = 10,
		damage = 4,
		reach = 2,
		attack_type = "dogfight",
		group_attack = true,
		view_range = 10,
		walk_chance = 75,
		walk_velocity = 0.5,
		run_velocity = 0.5,
		jump = false,
		drops = {
			{name = "mobs_zombie:rotten_flesh", chance = 1, min = 1, max = 3,}
		},
		lifetimer = 180,		-- 3 minutes
		shoot_interval = 135,	-- (lifetimer - (lifetimer / 4)), borrowed for do_custom timer
		do_custom = function(self)
			if ENABLE_MINI_ZOMBIE and self.lifetimer <= self.shoot_interval then
				if math.random(100) <= 50 then
					minetest.add_entity(self.object:getpos(), "mobs_zombie:zombie_mini")
				end
				self.shoot_interval = self.shoot_interval - 45
			end
		end
	})

	--name, nodes, neighbors, min_light, max_light, interval, chance, active_object_count, min_height, max_height
	mobs:spawn_specific("mobs_zombie:zombie",
		{"default:stone", "default:dirt_with_grass"},
		{"air"},
		-1, 20, 30, 20000, 2, -31000, 31000
	)
	mobs:register_egg("mobs_zombie:zombie", "Zombie", "zombie_head.png", 0)
	
-- mini zombie
	if ENABLE_MINI_ZOMBIE then
		mobs:register_mob("mobs_zombie:zombie_mini", {
			type = "monster",
			visual = "mesh",
			mesh = "creatures_mob.x",
			textures = {
				{"mobs_zombie.png"},
			},
			visual_size = {x = 0.5, y = 0.5},
			collisionbox = {-0.125, -0.5, -0.15, 0.125, 0.375, 0.15},
			animation = {
				speed_normal = 10,		speed_run = 15,
				stand_start = 0,		stand_end = 79,
				walk_start = 168,		walk_end = 188,
				run_start = 168,		run_end = 188
			},
			makes_footstep_sound = true,
			sounds = {
				random = "mobs_zombie.1",
				war_cry = "mobs_zombie.3",
				attack = "mobs_zombie.2",
				damage = "mobs_zombie_hit",
				death = "mobs_zombie_death"
			},
			hp_min = 20,
			hp_max = 45,
			armor = 150,
			knock_back = 1,
			lava_damage = 10,
			damage = 6,
			reach = 1,
			attack_type = "dogfight",
			group_attack = true,
			view_range = 10,
			walk_chance = 75,
			walk_velocity = 0.8,
			run_velocity = 0.8,
			jump = false,
			drops = {
				{name = "mobs_zombie:rotten_flesh", chance = 1, min = 1, max = 1,}
			}
		})
	end

-- rotten flesh
	minetest.register_craftitem("mobs_zombie:rotten_flesh", {
		description = "Rotten Flesh",
		inventory_image = "mobs_rotten_flesh.png",
		on_use = minetest.item_eat(1),
	})

end
