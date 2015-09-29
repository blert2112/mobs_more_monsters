
-- Yeti by TenPlus1

if mobs.mod and mobs.mod == "redo" then

	local ENABLE_SPAWN_NODE = true

-- yeti
	mobs:register_mob("mobs_yeti:yeti", {
		type = "monster",
		visual = "mesh",
		mesh = "character.b3d",
		textures = {
			{"mobs_yeti.png"},
		},
		collisionbox = {-0.35,-1.0,-0.35, 0.35,0.8,0.35},
		animation = {
			speed_normal = 30,	speed_run = 30,
			stand_start = 0,	stand_end = 79,
			walk_start = 168,	walk_end = 187,
			run_start = 168,	run_end = 187,
			punch_start = 200,	punch_end = 219
		},
		makes_footstep_sound = true,
		sounds = {
			random = "mobs_stonemonster",
		},
		hp_min = 10,
		hp_max = 35,
		armor = 100,
		knock_back = 1,
		light_damage = 1,
		water_damage = 1,
		lava_damage = 15,
		fall_damage = 15,
		damage = 2,
		reach = 2,
		attack_type = "dogshoot",
		arrow = "mobs_yeti:snowball",
		shoot_interval = .7,
		shoot_offset = 2,
		view_range = 15,
		run_velocity = 3,
		stepheight = 1.1,
		floats = 0,
		drops = {
			{name = "default:ice", chance = 1, min = 1, max = 3,}
		},
		replace_rate = 50,
		replace_what = {"air"},
		replace_with = "default:snow",
		replace_offset = -1
	})

	local l_spawn_elevation_min = minetest.setting_get("water_level")+1 or 1
	--name, nodes, neighbors, min_light, max_light, interval, chance, active_object_count, min_height, max_height
	mobs:spawn_specific("mobs_yeti:yeti",
		{"default:dirt_with_snow", "default:snow", "default:snowblock", "default:ice"},
		{"air"},
		-1, 10, 30, 20000, 1, l_spawn_elevation_min, 31000
	)
	mobs:register_egg("mobs_yeti:yeti", "Yeti", "default_snow.png", 1)

	mobs:register_arrow("mobs_yeti:snowball", {
		visual = "sprite",
		visual_size = {x=.5, y=.5},
		textures = {"default_snowball.png"},
		velocity = 6,
		hit_player = function(self, player)
			player:punch(self.object, 1.0,  {
				full_punch_interval=1.0,
				damage_groups = {fleshy=1},
			}, 0)
		end,
		hit_mob = function(self, player)
			player:punch(self.object, 1.0,  {
				full_punch_interval=1.0,
				damage_groups = {fleshy=1},
			}, 0)
		end,
		hit_node = function(self, pos, node)
		end
	})

-- snowball throwing item
	local snowball_GRAVITY=9
	local snowball_VELOCITY=19

-- shoot snowball
	local mobs_shoot_snowball=function (item, player, pointed_thing)
		local playerpos=player:getpos()
		local obj=minetest.add_entity({x=playerpos.x,y=playerpos.y+1.5,z=playerpos.z}, "mobs_yeti:snowball")
		local dir=player:get_look_dir()
		obj:get_luaentity().velocity = snowball_VELOCITY -- needed for api internal timing
		obj:setvelocity({x=dir.x*snowball_VELOCITY, y=dir.y*snowball_VELOCITY, z=dir.z*snowball_VELOCITY})
		obj:setacceleration({x=dir.x*-3, y=-snowball_GRAVITY, z=dir.z*-3})
		item:take_item()
		return item
	end

-- spawner block
	if ENABLE_SPAWN_NODE then
		minetest.register_node("mobs_yeti:yeti_spawner", {
			description = "Yeti Spawner",
			tiles = {"mobs_yeti_face.png"},
			is_ground_content = false,
			groups = {cracky=3, stone=1, mob_spawner=1},
			sounds = default.node_sound_stone_defaults({
				dug = {name="mobs_stonemonster", gain=0.25}
			})
		})
		minetest.register_abm({
			nodenames = {"mobs_yeti:yeti_spawner"},
			interval = 60.0,
			chance = 1,
			action = function(pos, node, active_object_count, active_object_count_wider)
				minetest.add_entity(pos, "mobs_yeti:yeti")
			end
		})
	end

end
