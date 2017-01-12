
local function max(x, y)
	if x > y then return x end
	return y
end

local function min(x, y)
	if x < y then return x end
	return y
end

local function maxpos(pos1, pos2)
	return {
		x = max(pos1.x, pos2.x),
		y = max(pos1.y, pos2.y),
		z = max(pos1.z, pos2.z)
	}
end

local function minpos(pos1, pos2)
	return {
		x = min(pos1.x, pos2.x),
		y = min(pos1.y, pos2.y),
		z = min(pos1.z, pos2.z)
	}
end

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
			speed_normal = 10,	speed_run = 10,
			stand_start = 0,	stand_end = 14,
			walk_start = 15,	walk_end = 38,
			run_start = 40,		run_end = 63,
			punch_start = 40,	punch_end = 63
		},
		hp_min = 15,
		hp_max = 30,
		armor = 80,
		light_damage = 2,
		damage = 6,
		reach = 4,
		attack_type = "dogfight",
		view_range = 30,
		walk_velocity = 0.5,
		run_velocity = 1,
		stepheight = 1.1,
		drops = {
			{name = "default:nyancat", chance = 2, min = 1, max = 2,}
		},
		do_custom = function(self, dtime)
			if not self.attack then return end
			local freq = 3 -- how frequently it uses this ability
			local berth = 3 -- minimum size area for teleports

			if not self.timeout then
				self.timeout = 0
			end

			self.timeout = self.timeout + dtime
			if self.timeout < freq then
				return false
			end
			
			self.timeout = 0

			local playerpos = self.attack:getpos()
			local mobpos = self.object:getpos()

			if vector.distance(playerpos, mobpos) < self.reach then
				return
			end

			-- ensure a wide enough box for randomness
			if math.abs(mobpos.x - playerpos.x) < berth*2 then
				playerpos.x = playerpos.x - berth
				mobpos.x = mobpos.x + berth
			end

			if math.abs(mobpos.z - playerpos.z) < berth*2 then
				playerpos.z = playerpos.z - berth
				mobpos.z = mobpos.z + berth
			end

			local airnodes = minetest.find_nodes_in_area( minpos(mobpos,playerpos), maxpos(mobpos,playerpos), {"air"})

			local targetpos = airnodes[math.random(1, #airnodes)]
			if minetest.is_protected(targetpos, "") then
				return
			end

			local radius = 1
			minetest.add_particlespawner(
				200, --amount
				0.1, --time
				{x=targetpos.x-radius/2, y=targetpos.y-radius/2, z=targetpos.z-radius/2}, --mintargetpos
				{x=targetpos.x+radius/2, y=targetpos.y+radius/2, z=targetpos.z+radius/2}, --maxtargetpos
				{x=-0, y=-0, z=-0}, --minvel
				{x=1, y=1, z=1}, --maxvel
				{x=-0.5,y=5,z=-0.5}, --minacc
				{x=0.5,y=5,z=0.5}, --maxacc
				0.1, --minexptime
				1, --maxexptime
				3, --minsize
				4, --maxsize
				false, --collisiondetection
				"tnt_smoke.png" --texture
			)


			self.object:setpos(targetpos)
			minetest.sound_play("senderman_woosh",{
				pos = targetpos,
			})


			return true
		end
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
