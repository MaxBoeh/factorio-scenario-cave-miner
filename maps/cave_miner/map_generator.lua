
local Event = require 'utils.event' 
local simplex_noise = require 'utils.simplex_noise'

local function on_chunk_generated(event)
	if not global.noise_seed then global.noise_seed = math.random(1,5000000) end	
	local surface = game.surfaces[1]	
	local noise = {}
	local tiles = {}	
	local enemy_building_positions = {}
	local enemy_worm_positions = {}
	local enemy_can_place_worm_positions = {}
	local rock_positions = {}
	local fish_positions = {}
	local rare_treasure_chest_positions = {}
	local treasure_chest_positions = {}
	local secret_shop_locations = {}
	local extra_tree_positions = {}
	local spawn_tree_positions = {}
	local tile_to_insert = false
	local entity_has_been_placed = false
	local pos_x = 0
	local pos_y = 0
	local tile_distance_to_center = 0			
	local entities = surface.find_entities(event.area)
	for _, e in pairs(entities) do
		if e.type == "resource" or e.type == "tree" or e.force.name == "enemy" then
			e.destroy()				
		end
	end	
	local noise_seed_add = 25000
	local current_noise_seed_add = noise_seed_add	
	local m1 = 0.13
	local m2 = 0.13    --10
	local m3 = 0.10    --07
	
	local tree_size = game.surfaces[1].map_gen_settings.autoplace_controls.trees.size -- value 0 - 6
	local tree_threshold = (1 - (tree_size / 6)) * 0.5
	
	for x = 0, 31, 1 do
		for y = 0, 31, 1 do			
			pos_x = event.area.left_top.x + x
			pos_y = event.area.left_top.y + y
			tile_distance_to_center = pos_x^2 + pos_y^2
									
			noise[1] = simplex_noise.d2(pos_x/350, pos_y/350,global.noise_seed+current_noise_seed_add)
			current_noise_seed_add = current_noise_seed_add + noise_seed_add
			noise[2] = simplex_noise.d2(pos_x/200, pos_y/200,global.noise_seed+current_noise_seed_add)
			current_noise_seed_add = current_noise_seed_add + noise_seed_add
			noise[3] = simplex_noise.d2(pos_x/50, pos_y/50,global.noise_seed+current_noise_seed_add)
			current_noise_seed_add = current_noise_seed_add + noise_seed_add
			noise[4] = simplex_noise.d2(pos_x/20, pos_y/20,global.noise_seed+current_noise_seed_add)
			current_noise_seed_add = current_noise_seed_add + noise_seed_add			
			local cave_noise = noise[1] + noise[2]*0.35 + noise[3]*0.05 + noise[4]*0.015
			
			noise[1] = simplex_noise.d2(pos_x/120, pos_y/120,global.noise_seed+current_noise_seed_add)
			current_noise_seed_add = current_noise_seed_add + noise_seed_add
			noise[2] = simplex_noise.d2(pos_x/60, pos_y/60,global.noise_seed+current_noise_seed_add)
			current_noise_seed_add = current_noise_seed_add + noise_seed_add
			noise[3] = simplex_noise.d2(pos_x/40, pos_y/40,global.noise_seed+current_noise_seed_add)
			current_noise_seed_add = current_noise_seed_add + noise_seed_add
			noise[4] = simplex_noise.d2(pos_x/20, pos_y/20,global.noise_seed+current_noise_seed_add)
			current_noise_seed_add = current_noise_seed_add + noise_seed_add			
			local cave_noise_2 = noise[1] + noise[2]*0.30 + noise[3]*0.20 + noise[4]*0.09
			
			noise[1] = simplex_noise.d2(pos_x/50, pos_y/50,global.noise_seed+current_noise_seed_add)
			current_noise_seed_add = current_noise_seed_add + noise_seed_add
			noise[2] = simplex_noise.d2(pos_x/30, pos_y/30,global.noise_seed+current_noise_seed_add)
			current_noise_seed_add = current_noise_seed_add + noise_seed_add
			noise[3] = simplex_noise.d2(pos_x/20, pos_y/20,global.noise_seed+current_noise_seed_add)
			current_noise_seed_add = current_noise_seed_add + noise_seed_add
			noise[4] = simplex_noise.d2(pos_x/10, pos_y/10,global.noise_seed+current_noise_seed_add)
			current_noise_seed_add = current_noise_seed_add + noise_seed_add			
			local cave_noise_3 = noise[1] + noise[2]*0.5 + noise[3]*0.25 + noise[4]*0.1
			
			current_noise_seed_add = noise_seed_add	
			
			tile_to_insert = false	
			if tile_distance_to_center > global.spawn_dome_size then												
			
				if tile_distance_to_center > (global.spawn_dome_size + 5000) * (cave_noise_3 * 0.05 + 1.1) then
					if cave_noise > 1 then
						tile_to_insert = "deepwater"
						table.insert(fish_positions, {pos_x,pos_y})
					else
						if cave_noise > 0.98 then 
							tile_to_insert = "water"
						else
							if cave_noise > 0.82 then
								tile_to_insert = "grass-1"
								table.insert(enemy_building_positions, {pos_x,pos_y})
								table.insert(enemy_can_place_worm_positions, {pos_x,pos_y})
								--tile_to_insert = "grass-4"
								--if cave_noise > 0.88 then tile_to_insert = "grass-2" end
								if cave_noise > 0.94 then
									table.insert(extra_tree_positions, {pos_x,pos_y})
									table.insert(secret_shop_locations, {pos_x,pos_y})									
								end								
							else
								if cave_noise > 0.72 then
									tile_to_insert = "dirt-6"
									if cave_noise < 0.79 then table.insert(rock_positions, {pos_x,pos_y}) end
								end
							end
						end	
						if cave_noise < -0.80 then
							tile_to_insert = "dirt-6"
							if noise[3] > 0.18 or noise[3] < -0.18 then
								table.insert(rock_positions, {pos_x,pos_y})
								table.insert(enemy_worm_positions, {pos_x,pos_y})
								table.insert(enemy_worm_positions, {pos_x,pos_y})
								table.insert(enemy_worm_positions, {pos_x,pos_y})								
							else
								tile_to_insert = "sand-3"
								table.insert(treasure_chest_positions, {{pos_x,pos_y}, tile_distance_to_center})
								table.insert(treasure_chest_positions, {{pos_x,pos_y}, tile_distance_to_center})
								table.insert(treasure_chest_positions, {{pos_x,pos_y}, tile_distance_to_center})
								table.insert(treasure_chest_positions, {{pos_x,pos_y}, tile_distance_to_center})
								table.insert(rare_treasure_chest_positions, {pos_x,pos_y})								
							end
						else
							if cave_noise < -0.75 then
								tile_to_insert = "dirt-6"
								if cave_noise > -0.78 then table.insert(rock_positions, {pos_x,pos_y}) end
							end
						end						
					end
				end
				
				if tile_to_insert == false then
					if cave_noise < m1 and cave_noise > m1*-1 then
						tile_to_insert = "dirt-7"
						if cave_noise < 0.06 and cave_noise > -0.06 and noise[1] > 0.4 and tile_distance_to_center > global.spawn_dome_size + 5000 then
							table.insert(enemy_can_place_worm_positions, {pos_x,pos_y})
							table.insert(enemy_can_place_worm_positions, {pos_x,pos_y})
							table.insert(enemy_can_place_worm_positions, {pos_x,pos_y})
							table.insert(enemy_can_place_worm_positions, {pos_x,pos_y})
							table.insert(enemy_building_positions, {pos_x,pos_y})
							table.insert(enemy_building_positions, {pos_x,pos_y})
							table.insert(enemy_building_positions, {pos_x,pos_y})
							table.insert(enemy_building_positions, {pos_x,pos_y})
							table.insert(enemy_building_positions, {pos_x,pos_y})
						else
							table.insert(rock_positions, {pos_x,pos_y})
							if math.random(1,3) == 1 then table.insert(enemy_worm_positions, {pos_x,pos_y}) end
						end
						if cave_noise_2 > 0.85 and tile_distance_to_center > global.spawn_dome_size + 25000 then
							if math.random(1,48) == 1 then
								local p = surface.find_non_colliding_position("crude-oil",{pos_x,pos_y}, 5,1)
								if p then
									surface.create_entity {name="crude-oil", position=p, amount=math.floor(math.random(25000+tile_distance_to_center*0.5,50000+tile_distance_to_center),0)}
								end
							end
						end
					else
						if cave_noise_2 < m2 and cave_noise_2 > m2*-1 then
							tile_to_insert = "dirt-4"
							table.insert(rock_positions, {pos_x,pos_y})
							table.insert(treasure_chest_positions, {{pos_x,pos_y}, tile_distance_to_center})								
						else
							if cave_noise_3 < m3 and cave_noise_3 > m3*-1 and cave_noise_2 < m2+0.3 and cave_noise_2 > (m2*-1)-0.3 then
								tile_to_insert = "dirt-2"
								table.insert(rock_positions, {pos_x,pos_y})	
								table.insert(treasure_chest_positions, {{pos_x,pos_y}, tile_distance_to_center})
								table.insert(treasure_chest_positions, {{pos_x,pos_y}, tile_distance_to_center})
								table.insert(treasure_chest_positions, {{pos_x,pos_y}, tile_distance_to_center})
							end
						end
					end
				end
				
				if tile_distance_to_center < global.spawn_dome_size * (cave_noise_3 * 0.05 + 1.1)  then	
					if tile_to_insert == false then table.insert(rock_positions, {pos_x,pos_y}) end
					tile_to_insert = "dirt-7"					
				end
			else
				if tile_distance_to_center < 750 * (1 + cave_noise_3 * 0.8) then
					tile_to_insert = "water"
					table.insert(fish_positions, {pos_x,pos_y})
				else
					tile_to_insert = "grass-1"
					
					if cave_noise_3 > tree_threshold and tile_distance_to_center + 3000 < global.spawn_dome_size then
						table.insert(spawn_tree_positions, {pos_x,pos_y})
					end
				end
			end
			
			if tile_distance_to_center < global.spawn_dome_size and tile_distance_to_center > global.spawn_dome_size - 500 and tile_to_insert == "grass-1" then
				table.insert(rock_positions, {pos_x,pos_y})	
			end						
			
			if tile_to_insert == false then
				table.insert(tiles, {name = "out-of-map", position = {pos_x,pos_y}}) 
			else
				table.insert(tiles, {name = tile_to_insert, position = {pos_x,pos_y}}) 
			end					
		end							
	end
	surface.set_tiles(tiles,true)
		
	for _, k in pairs(treasure_chest_positions) do	
		if math.random(1,800)==1 then 
			treasure_chest(k[1], k[2])
		end
	end
	for _, p in pairs(rare_treasure_chest_positions) do	
		if math.random(1,100)==1 then 
			rare_treasure_chest(p)
		end
	end
	
	for _, p in pairs(rock_positions) do
		local x = math.random(1,100)
		if x < global.rock_density then	
			surface.create_entity {name=global.rock_raffle[math.random(1,#global.rock_raffle)], position=p}						
		end
		--[[
		local z = 1
		if p[2] % 2 == 1 then z = 0 end
		if p[1] % 2 == z then
			surface.create_entity {name=global.rock_raffle[math.random(1,#global.rock_raffle)], position=p}			
		end
		]]--
	end
	
	for _, p in pairs(enemy_building_positions) do	
		if math.random(1,50)==1 then
			local pos = surface.find_non_colliding_position("biter-spawner", p, 8, 1)
			if pos then
				if math.random(1,3) == 1 then
					surface.create_entity {name="spitter-spawner",position=pos}
				else
					surface.create_entity {name="biter-spawner",position=pos}
				end
			end			
		end
	end	
	
	for _, p in pairs(enemy_worm_positions) do		
		if math.random(1,300)==1 then
			local tile_distance_to_center = math.sqrt(p[1]^2 + p[2]^2)
			if tile_distance_to_center > global.worm_free_zone_radius then						
				local raffle_index = math.ceil((tile_distance_to_center-global.worm_free_zone_radius)*0.01, 0)
				if raffle_index < 1 then raffle_index = 1 end
				if raffle_index > 5 then raffle_index = 5 end					
				local entity_name = worm_raffle_table[raffle_index][math.random(1,#worm_raffle_table[raffle_index])]												
				surface.create_entity {name=entity_name, position=p}
			end
		end
	end	
	
	for _, p in pairs(enemy_can_place_worm_positions) do		
		if math.random(1,30)==1 then
			local tile_distance_to_center = math.sqrt(p[1]^2 + p[2]^2)
			if tile_distance_to_center > global.worm_free_zone_radius then						
				local raffle_index = math.ceil((tile_distance_to_center-global.worm_free_zone_radius)*0.01, 0)
				if raffle_index < 1 then raffle_index = 1 end
				if raffle_index > 5 then raffle_index = 5 end					
				local entity_name = worm_raffle_table[raffle_index][math.random(1,#worm_raffle_table[raffle_index])]												
				if surface.can_place_entity({name=entity_name, position=p}) then surface.create_entity {name=entity_name, position=p} end
			end
		end
	end
		
	for _, p in pairs(fish_positions) do	
		if math.random(1,16)==1 then
			if surface.can_place_entity({name="fish",position=p}) then
				surface.create_entity {name="fish",position=p}
			end
		end
	end
		
	for _, p in pairs(secret_shop_locations) do	
		if math.random(1,10)==1 then
			if surface.count_entities_filtered{area={{p[1]-125,p[2]-125},{p[1]+125,p[2]+125}}, name="market", limit=1} == 0 then
				secret_shop(p)
			end
		end
	end		
	
	for _, p in pairs(spawn_tree_positions) do	
		if math.random(1,6)==1 then 
			surface.create_entity {name="tree-04",position=p}
		end
	end	
	
	for _, p in pairs(extra_tree_positions) do	
		if math.random(1,20)==1 then 
			surface.create_entity {name="tree-02",position=p}
		end
	end				
	
	local decorative_names = {}
	for k,v in pairs(game.decorative_prototypes) do
		if v.autoplace_specification then
		  decorative_names[#decorative_names+1] = k
		end
	 end	 
	surface.regenerate_decorative(decorative_names, {{x=math.floor(event.area.left_top.x/32),y=math.floor(event.area.left_top.y/32)}})		
end

Event.add(defines.events.on_chunk_generated, on_chunk_generated)
