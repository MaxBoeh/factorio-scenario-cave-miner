
local Event = require 'utils.event' 
local config = require "maps.cave_miner.config"
local gui = require "maps.cave_miner.gui"

local function init_scenario()
    
	local surface = game.surfaces[1]
	local gen_settings = surface.map_gen_settings
	
	game.forces["player"].set_spawn_position(
        surface.find_non_colliding_position("player", {0,-40}, 10, 1),
        surface
    )
	surface.daytime = 0.5
	surface.freeze_daytime = 1
	game.forces["player"].technologies["landfill"].enabled = false
	game.forces["player"].technologies["night-vision-equipment"].enabled = false
	game.forces["player"].technologies["artillery-shell-range-1"].enabled = false			
	game.forces["player"].technologies["artillery-shell-speed-1"].enabled = false
	game.forces["player"].technologies["artillery"].enabled = false	
	game.forces["player"].technologies["atomic-bomb"].enabled = false	
	
	game.map_settings.enemy_evolution.destroy_factor = 0.004
	
	global.cave_miner_map_info = config.map_info
	global.player_hunger = {}
	global.player_based_data = {}
					
	global.damaged_rocks = {}
	
	global.rock_density = 62  ---- insert value up to 100
	global.rock_raffle = {"sand-rock-big","sand-rock-big","rock-big","rock-big","rock-big","rock-big","rock-big","rock-big","rock-huge"}
	
	-- generate noice seed based on the map seed
	local seed_random = game.create_random_generator()
	global.noise_seed = seed_random(1,5000000)
	
	-- starting area is based on the starting area size setting.
	global.spawn_dome_size = 20000 * gen_settings.starting_area;
	
	global.worm_free_zone_radius = math.sqrt(global.spawn_dome_size) + 40
	
	global.ore_spill_cap = 35
	global.stats_rocks_broken = 0
	global.stats_ores_found = 0
	global.total_ores_mined = 0
	
	global.rock_mining_chance_weights = {}
	global.rock_mining_chance_weights[1] = {"iron-ore",25}
	global.rock_mining_chance_weights[2] = {"copper-ore",18}
	global.rock_mining_chance_weights[3] = {"coal",14}
	global.rock_mining_chance_weights[4] = {"uranium-ore",3}
	global.rock_mining_raffle_table = {}				
	for _, t in pairs (global.rock_mining_chance_weights) do
		for x = 1, t[2], 1 do
			table.insert(global.rock_mining_raffle_table, t[1])
		end			
	end

	global.darkness_threat_level = {}							
	
	gui.init()

	global.scenario_init_done = true	
end

local function init_player(player)
	if player.online_time < 10 then
        player.teleport(game.forces["player"].get_spawn_position(game.surfaces[1]))
		global.darkness_threat_level[player.name] = 0
		player.insert {name = 'pistol', count = 1}
		player.insert {name = 'firearm-magazine', count = 30}
		player.insert {name = 'coin', count = 10}
		player.insert {name = 'raw-fish', count = 50}
	end 
	
	global.player_based_data[player.index] = {}
end

local function on_player_joined_game(event)
	if global.scenario_init_done == false or global.scenario_init_done == nil then
		init_scenario()
	end

    init_player(game.players[event.player_index])
end

Event.add(defines.events.on_player_joined_game, on_player_joined_game)