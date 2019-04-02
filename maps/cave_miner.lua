--Factorio Cave Miner -- mewmew made this --
--You can use /c map_pregen() command to pre-generate the world before playing to avoid any possible microstutter while playing.--
--Use /c spaghetti() to play without bots.

local Event = require 'utils.event' 

require "maps.cave_miner.initialization"
require "maps.cave_miner.kaboomsticks"
require "maps.tools.map_pregen"

local biter_attacks = require "maps.cave_miner.biter_attacks"
local config = require "maps.cave_miner.config"
local debug = require "maps.tools.debug"
local gui = require "maps.cave_miner.gui"
local map_generator = require "maps.cave_miner.map_generator"
local market_items = require "maps.cave_miner.market_items"

-- debug.enable()

local rock_inhabitants = {
	[1] = {"small-biter"},
	[2] = {"small-biter","small-biter"},
	[3] = {"small-biter","small-biter","small-biter"},
	[4] = {"small-biter","small-biter","small-biter","small-biter"},
	[5] = {"small-biter","small-biter","small-biter","medium-biter"},
	[6] = {"small-biter","small-biter","medium-biter","medium-biter"},
	[7] = {"small-biter","medium-biter","medium-biter","medium-biter"},
	[8] = {"small-biter","medium-biter","medium-biter","medium-biter"},
	[9] = {"small-biter","medium-biter","medium-biter","medium-spitter","big-biter"},
	[10] = {"medium-biter","medium-biter","medium-biter","big-biter","big-biter"},
	[11] = {"medium-biter","medium-biter","big-biter","big-biter","big-spitter"},
	[12] = {"medium-biter","big-biter","big-biter","big-biter","big-spitter"},
	[13] = {"big-biter","big-biter","big-biter","big-biter","big-biter"},
	[14] = {"big-biter","big-biter","big-biter","big-biter","big-spitter","big-spitter"},
	[15] = {"big-biter","big-biter","big-biter","behemoth-biter","big-spitter","big-spitter"},
	[16] = {"big-biter","big-biter","big-biter","behemoth-biter","behemoth-biter","behemoth-spitter"},
	[17] = {"big-biter","big-biter","behemoth-biter","behemoth-biter","behemoth-biter","behemoth-spitter"},
	[18] = {"big-biter","behemoth-biter","behemoth-biter","behemoth-biter","behemoth-biter","behemoth-spitter"},
	[19] = {"behemoth-biter","behemoth-biter","behemoth-biter","behemoth-biter","behemoth-biter","behemoth-spitter"},
	[20] = {"behemoth-biter","behemoth-biter","behemoth-biter","behemoth-biter","behemoth-spitter","behemoth-spitter"}
}

local player_hunger_buff = config.player_hunger_buff
		
local function hunger_update(player, food_value)
	
	if food_value == -1 and player.character.driving == true then return end
	
	local past_hunger = global.player_hunger[player.name]	
	global.player_hunger[player.name] = global.player_hunger[player.name] + food_value
	if global.player_hunger[player.name] > 200 then global.player_hunger[player.name] = 200 end
			
	if past_hunger == 200 and global.player_hunger[player.name] + food_value > 200 then
		global.player_hunger[player.name] = config.player_hunger_spawn_value
		player.character.die("player")
		local t = {" ate too much and exploded.", " should have gone on a diet.", " needs to work on their bad eating habbits.", " should have skipped dinner today."}
		game.print(player.name .. t[math.random(1,#t)], { r=0.75, g=0.0, b=0.0})				
	end	
	
	if global.player_hunger[player.name] < 1 then
		global.player_hunger[player.name] = config.player_hunger_spawn_value
		player.character.die("player")
		local t = {" ran out of foodstamps.", " starved.", " should not have skipped breakfast today."}
		game.print(player.name .. t[math.random(1,#t)], { r=0.75, g=0.0, b=0.0})	
	end
	
	local player_hunger_stages = config.player_hunger_stages
	if player.character then
		if player_hunger_stages[global.player_hunger[player.name]] ~= player_hunger_stages[past_hunger] then
			local print_message = "You feel " .. player_hunger_stages[global.player_hunger[player.name]] .. "."
			if player_hunger_stages[global.player_hunger[player.name]] == "Obese" then
				print_message = "You have become " .. player_hunger_stages[global.player_hunger[player.name]]  .. "."					
			end
			if player_hunger_stages[global.player_hunger[player.name]] == "Starving" then
				print_message = "You are starving!"
			end
			player.print(print_message, config.player_hunger_color_list[global.player_hunger[player.name]])
		end
	end
	
	player.character.character_running_speed_modifier = player_hunger_buff[global.player_hunger[player.name]] * 0.5
	player.character.character_mining_speed_modifier  = player_hunger_buff[global.player_hunger[player.name]]
end

local function on_player_joined_game(event)
	debug.log("main.on_player_joined_game")
	local player = game.players[event.player_index]

	global.player_hunger[player.name] = config.player_hunger_spawn_value
	hunger_update(player, 0)
	gui.refresh_gui(player.index)
end

local function spawn_cave_inhabitant(pos, target_position)
	if not pos.x then return nil end
	if not pos.y then return nil end
	local surface = game.surfaces[1]
	local tile_distance_to_center = math.sqrt(pos.x^2 + pos.y^2)			
	local rock_inhabitants_index = math.ceil((tile_distance_to_center-math.sqrt(global.spawn_dome_size))*0.015, 0)
	if rock_inhabitants_index < 1 then rock_inhabitants_index = 1 end
	if rock_inhabitants_index > #rock_inhabitants then rock_inhabitants_index = #rock_inhabitants end					
	local entity_name = rock_inhabitants[rock_inhabitants_index][math.random(1,#rock_inhabitants[rock_inhabitants_index])]
	local p = surface.find_non_colliding_position(entity_name , pos, 6, 0.5)
	local biter = 1
	if p then biter = surface.create_entity {name=entity_name, position=p} end
	if target_position then biter.set_command({type=defines.command.attack_area, destination=target_position, radius=5, distraction=defines.distraction.by_anything}) end
	if not target_position then biter.set_command({type=defines.command.attack_area, destination=game.forces["player"].get_spawn_position(surface), radius=5, distraction=defines.distraction.by_anything}) end
end

local function darkness_events()
	for _, p in pairs (game.connected_players) do		
		if global.darkness_threat_level[p.name] > 4 then						
			for x = 1, 2 + global.darkness_threat_level[p.name], 1 do
				spawn_cave_inhabitant(p.position)	
			end				
			local biters_found = game.surfaces[1].find_enemy_units(p.position, 8, "player")
			for _, biter in pairs(biters_found) do				
				biter.set_command({type=defines.command.attack, target=p.character, distraction=defines.distraction.none})					
			end
			p.character.damage(math.random(global.darkness_threat_level[p.name]*1,global.darkness_threat_level[p.name]*2),"enemy")
		end		
		if global.darkness_threat_level[p.name] == 2 then
			p.print(config.darkness_messages[math.random(1,#config.darkness_messages)],{ r=0.65, g=0.0, b=0.0})				
		end
		global.darkness_threat_level[p.name] = global.darkness_threat_level[p.name] + 1
	end
end

local function darkness_checks()
	for _, p in pairs (game.connected_players) do
		if p.character then p.character.disable_flashlight() end		
		local tile_distance_to_center = math.sqrt(p.position.x^2 + p.position.y^2)
		if tile_distance_to_center < math.sqrt(global.spawn_dome_size) then
			global.darkness_threat_level[p.name] = 0
		else
			if p.character and p.character.driving == true then
				global.darkness_threat_level[p.name] = 0
			else
				local light_source_entities = game.surfaces[1].find_entities_filtered{area={{p.position.x-12,p.position.y-12},{p.position.x+12,p.position.y+12}}, name="small-lamp"}		
				for _, lamp in pairs (light_source_entities) do
					local circuit = lamp.get_or_create_control_behavior()
					if circuit then
						if lamp.energy > 50 and circuit.disabled == false then					
							global.darkness_threat_level[p.name] = 0
							break
						end
					else
						if lamp.energy > 50 then					
							global.darkness_threat_level[p.name] = 0
							break
						end
					end
				end
			end
		end
	end
end

local function on_tick(event)
	if game.tick % 960 == 0 then
		darkness_checks()	
		darkness_events()
	end		
	
	if game.tick % 5400 == 2700 then
		for _, player in pairs(game.connected_players) do
			if player.afk_time < 18000 then	
				hunger_update(player, -1)
				gui.refresh_gui(player.index)
			end
		end
	end
	
	if game.tick == 30 then
		local surface = game.surfaces[1]
		local p = game.surfaces[1].find_non_colliding_position("market",{0,-15},60,0.5)
		local market = surface.create_entity {name = "market", position = p}
		market.destructible = false
		
		for _, item in pairs(market_items.spawn) do
			market.add_market_item(item)
		end

		surface.regenerate_entity({"rock-big","rock-huge"})			
	end
end

local disabled_for_deconstruction = {
	["fish"] = true,
	["rock-huge"] = true,
	["rock-big"] = true,
	["sand-rock-big"] = true,
	["tree-02"] = true,
	["tree-04"] = true
}
	
local function on_marked_for_deconstruction(event)	
	if disabled_for_deconstruction[event.entity.name] then
		event.entity.cancel_deconstruction(game.players[event.player_index].force.name)
	end
end

local function pre_player_mined_item(event)
	local surface = game.surfaces[1]
	local player = game.players[event.player_index]
	
	if math.random(1,12) == 1 then
		if event.entity.name == "rock-huge" or event.entity.name == "rock-big" or event.entity.name == "sand-rock-big" then		
			for x = 1, math.random(6, 10), 1 do
				biter_attacks.add_biter_spawn(game.tick + 15*x, event.entity.position)
			end
		end
	end
				
	if event.entity.type == "tree" then surface.spill_item_stack(player.position,{name = "coin", count = math.random(1,2)},true) end
	
	if event.entity.name == "rock-huge" or event.entity.name == "rock-big" or event.entity.name == "sand-rock-big" then		
		local rock_position = {x = event.entity.position.x, y = event.entity.position.y}
		event.entity.destroy()
		
		local distance_to_center = rock_position.x ^ 2 + rock_position.y ^ 2
		if math.random(1, 150) == 1 then
			map_generator.treasure_chest(rock_position, distance_to_center)
			player.print("You notice an old crate within the rubble. It´s filled with treasure!", { r=0.98, g=0.66, b=0.22})
		end
		
		local tile_distance_to_center = math.sqrt(rock_position.x^2 + rock_position.y^2)
		if tile_distance_to_center > 1450 then tile_distance_to_center = 1450 end	
		if math.random(1,3) == 1 then hunger_update(player, -1) end
		
		surface.spill_item_stack(player.position,{name = "coin", count = math.random(3,4)},true)
		local bonus_amount = math.ceil((tile_distance_to_center - math.sqrt(global.spawn_dome_size)) * 0.10, 0) 
		if bonus_amount < 1 then bonus_amount = 0 end		
		local amount = (math.random(45,55) + bonus_amount)*(1+game.forces.player.mining_drill_productivity_bonus)
		
		amount = math.round(amount, 0)
		amount_of_stone = math.round(amount * 0.15,0)		
		
		global.stats_ores_found = global.stats_ores_found + amount + amount_of_stone
		
		local mined_loot = global.rock_mining_raffle_table[math.random(1,#global.rock_mining_raffle_table)]
		if amount > global.ore_spill_cap then
			surface.spill_item_stack(rock_position,{name = mined_loot, count = global.ore_spill_cap},true)
			amount = amount - global.ore_spill_cap
			local i = player.insert {name = mined_loot, count = amount}
			amount = amount - i
			if amount > 0 then
				surface.spill_item_stack(rock_position,{name = mined_loot, count = amount},true)
			end
		else
			surface.spill_item_stack(rock_position,{name = mined_loot, count = amount},true)
		end
		
		if amount_of_stone > global.ore_spill_cap then
			surface.spill_item_stack(rock_position,{name = "stone", count = global.ore_spill_cap},true)
			amount_of_stone = amount_of_stone - global.ore_spill_cap
			local i = player.insert {name = "stone", count = amount_of_stone}
			amount_of_stone = amount_of_stone - i
			if amount_of_stone > 0 then
				surface.spill_item_stack(rock_position,{name = "stone", count = amount_of_stone},true)
			end
		else
			surface.spill_item_stack(rock_position,{name = "stone", count = amount_of_stone},true)
		end
		
		global.stats_rocks_broken = global.stats_rocks_broken + 1		
		gui.refresh_gui(event.player_index)
		
		if math.random(1,32) == 1 then				
			local p = {x = rock_position.x, y = rock_position.y}
			local tile_distance_to_center = p.x^2 + p.y^2
			if	tile_distance_to_center > global.spawn_dome_size + 100 then
				local radius = 32
				if surface.count_entities_filtered{area={{p.x - radius,p.y - radius},{p.x + radius,p.y + radius}}, type="resource", limit=1} == 0 then
					local size_raffle = {{"huge", 33, 42},{"big", 17, 32},{"", 8, 16},{"tiny", 3, 7}}
					local size = size_raffle[math.random(1,#size_raffle)]
					local ore_prints = {coal = {"dark", "Coal"}, ["iron-ore"] = {"shiny", "Iron"}, ["copper-ore"] = {"glimmering", "Copper"}, ["uranium-ore"] = {"glowing", "Uranium"}}
					player.print("You notice something " .. ore_prints[mined_loot][1] .. " underneath the rubble covered floor. It´s a " .. size[1] .. " vein of " ..  ore_prints[mined_loot][2] .. "!!", { r=0.98, g=0.66, b=0.22})
					tile_distance_to_center = math.sqrt(tile_distance_to_center)
					local ore_entities_placed = 0
					local modifier_raffle = {{0,-1},{-1,0},{1,0},{0,1}}
					while ore_entities_placed < math.random(size[2],size[3]) do						
						local a = math.ceil((math.random(tile_distance_to_center*4, tile_distance_to_center*5)) / 1 + ore_entities_placed * 0.5, 0)						
						for x = 1, 150, 1 do
							local m = modifier_raffle[math.random(1,#modifier_raffle)]
							local pos = {x = p.x + m[1], y = p.y + m[2]}
							if surface.can_place_entity({name=mined_loot, position=pos, amount=a}) then
								surface.create_entity {name=mined_loot, position=pos, amount=a}
								p = pos
								break
							end
						end
						ore_entities_placed = ore_entities_placed + 1
					end
				end
			end
		end		
	end
end

local function on_player_mined_entity(event)
	if event.entity.name == "rock-huge" or event.entity.name == "rock-big" or event.entity.name == "sand-rock-big" then
		event.buffer.clear()
	end
	if event.entity.name == "fish" then
		if math.random(1,2) == 1 then
			local player = game.players[event.player_index]	
			local health = player.character.health
			player.character.damage(math.random(50,150),"enemy")			
			if not player.character then
				game.print(player.name .. " should have kept their hands out of the foggy lake waters.",{ r=0.75, g=0.0, b=0.0} )
			else
				if health > 200 then
					player.print("You got bitten by an angry cave piranha.",{ r=0.75, g=0.0, b=0.0})
				else
					local messages = {"Ouch.. That hurt! Better be careful now.", "Just a fleshwound.", "Better keep those hands to yourself or you might loose them."}
					player.print(messages[math.random(1,#messages)],{ r=0.75, g=0.0, b=0.0})
				end
			end
		end
	end	
end

local function on_entity_damaged(event)	
	if event.entity.name == "rock-huge" or event.entity.name == "rock-big" or event.entity.name == "sand-rock-big" then
		local rock_is_alive = true
		if event.force.name == "enemy" then 
			event.entity.health = event.entity.health + (event.final_damage_amount - 0.2)
			if event.entity.health <= event.final_damage_amount then				
				rock_is_alive = false
			end			
		end
		if event.force.name == "player" then 
			event.entity.health = event.entity.health + (event.final_damage_amount * 0.8)
			if event.entity.health <= event.final_damage_amount then				
				rock_is_alive = false
			end			
		end		
		if event.entity.health <= 0 then rock_is_alive = false end		
		if rock_is_alive then
			global.damaged_rocks[tostring(event.entity.position.x) .. tostring(event.entity.position.y)] = {last_damage = game.tick, entity = event.entity}
		else
			global.damaged_rocks[tostring(event.entity.position.x) .. tostring(event.entity.position.y)] = nil
			if event.force.name == "player" then	
				if math.random(1,12) == 1 then								
					for x = 1, math.random(6,10), 1 do
						biter_attacks.add_biter_spawn({game.tick + 10*x, event.entity.position})
					end						
				end
			end
			local p = {x = event.entity.position.x, y = event.entity.position.y}
			local drop_amount = math.random(4, 8)
			event.entity.destroy()			
			game.surfaces[1].spill_item_stack(p,{name = "stone", count = drop_amount},true)
			
			local drop_amount_ore = math.random(16, 32)
			local ore = global.rock_mining_raffle_table[math.random(1, #global.rock_mining_raffle_table)]
			game.surfaces[1].spill_item_stack(p,{name = ore, count = drop_amount_ore},true)
			
			global.stats_rocks_broken = global.stats_rocks_broken + 1
			global.stats_ores_found = global.stats_ores_found + drop_amount + drop_amount_ore
		end
	end	
end

local function on_player_respawned(event)
	local player = game.players[event.player_index]
	player.insert {name = 'pistol', count = 1}
	player.insert {name = 'firearm-magazine', count = 10}			
	player.character.disable_flashlight()
	global.player_hunger[player.name] = config.player_hunger_spawn_value
	hunger_update(player, 0)
	gui.refresh_gui(player.index)
end

local function on_research_finished(event)
	game.forces.player.manual_mining_speed_modifier = game.forces.player.mining_drill_productivity_bonus * 6
	game.forces.player.character_inventory_slots_bonus = game.forces.player.mining_drill_productivity_bonus * 500
	gui.refresh_gui(event.player_index)
end

local function on_player_used_capsule(event)
	if event.item.name == "raw-fish" then
		local player = game.players[event.player_index]				
		hunger_update(player, config.player_hunger_fish_food_value)		
		player.play_sound{path="utility/armor_insert", volume_modifier=1}		
		gui.refresh_gui(event.player_index)
	end
end

Event.add(defines.events.on_player_used_capsule, on_player_used_capsule)
Event.add(defines.events.on_research_finished, on_research_finished)
Event.add(defines.events.on_player_respawned, on_player_respawned)
Event.add(defines.events.on_player_mined_entity, on_player_mined_entity)
Event.add(defines.events.on_entity_damaged, on_entity_damaged)
Event.add(defines.events.on_pre_player_mined_item, pre_player_mined_item)
Event.add(defines.events.on_marked_for_deconstruction, on_marked_for_deconstruction)
Event.add(defines.events.on_tick, on_tick)	
Event.add(defines.events.on_player_joined_game, on_player_joined_game)