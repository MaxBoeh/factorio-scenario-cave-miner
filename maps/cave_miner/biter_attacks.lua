
local Event = require 'utils.event' 

local biter_spawn_amount_raffle = {}
local biter_spawn_schedule = {}


local function get_biter_spawn_amount_raffle()
    local biter_spawn_amount_weights = {}				
    biter_spawn_amount_weights[1] = {64, 1}
    biter_spawn_amount_weights[2] = {32, 4}
    biter_spawn_amount_weights[3] = {16, 8}
    biter_spawn_amount_weights[4] = {8, 16}
    biter_spawn_amount_weights[5] = {4, 32}
    biter_spawn_amount_weights[6] = {2, 64}
    
    local biter_spawn_amount_raffle = {}
    for _, t in pairs (biter_spawn_amount_weights) do
        for x = 1, t[2], 1 do
            table.insert(biter_spawn_amount_raffle, t[1])
        end			
    end
    return biter_spawn_amount_raffle
end
biter_spawn_amount_raffle = get_biter_spawn_amount_raffle()

local function find_first_entity_spiral_scan(pos, entities, range)
	if not pos then return end
	if not entities then return end
	if not range then return end
	local surface = game.surfaces[1]
	local out_of_map_count = 0
	local out_of_map_cap = 1
	for z = 2,range,2 do
		pos.y = pos.y - 1
		pos.x = pos.x - 1
		for modifier = 1, -1, -2 do
			for x = 1, z, 1 do
				pos.x = pos.x + modifier	
				local t = surface.get_tile(pos)
				if t.name == "out-of-map" then out_of_map_count = out_of_map_count + 1 end				
				if out_of_map_count > out_of_map_cap then return end
				local e = surface.find_entities_filtered {position = pos, name = entities}						
				if e[1] then return e[1].position end
			end
			for y = 1, z, 1 do
				pos.y = pos.y + modifier	
				local t = surface.get_tile(pos)
				if t.name == "out-of-map" then out_of_map_count = out_of_map_count + 1 end
				if out_of_map_count > out_of_map_cap then return end
				local e = surface.find_entities_filtered {position = pos, name = entities}					
				if e[1] then return e[1].position end
			end
			if out_of_map_count > out_of_map_cap then return end
		end	
		if out_of_map_count > out_of_map_cap then return end				
	end		
end

local function biter_attack_event()
	local surface = game.surfaces[1]
	local valid_positions = {}
	for _, player in pairs(game.connected_players) do
		if player.character.driving == false then
			local position = {x = player.position.x, y = player.position.y}
			local p = find_first_entity_spiral_scan(position, {"rock-huge", "rock-big", "sand-rock-big"}, 48)
			if p then
				if p.x^2 + p.y^2 > global.spawn_dome_size then table.insert(valid_positions, p) end
			end
		end
	end
	if valid_positions[1] then
		if #valid_positions == 1 then
			for x = 1, biter_spawn_amount_raffle[math.random(1,#biter_spawn_amount_raffle)],1 do
				table.insert(biter_spawn_schedule, {game.tick + 20*x, valid_positions[1]})
			end
		end
		if #valid_positions > 1 then
			for y = math.random(1,2), #valid_positions, 2 do
				if y > #valid_positions then break end
				for x = 1, biter_spawn_amount_raffle[math.random(1,#biter_spawn_amount_raffle)],1 do
					table.insert(biter_spawn_schedule, {game.tick + 20*x, valid_positions[y]})
				end
			end
		end
	end
end	

local function on_tick(event)
	if game.tick % 30 == 0 then
		if biter_spawn_schedule then
			for x = 1, #biter_spawn_schedule, 1 do
				if biter_spawn_schedule[x] then
					if game.tick >= biter_spawn_schedule[x][1] then
						local pos = {
                            x = biter_spawn_schedule[x][2].x,
                            y = biter_spawn_schedule[x][2].y
                        }
						biter_spawn_schedule[x] = nil
						spawn_cave_inhabitant(pos)
					end
				end
			end
		end
    end
    
	if game.tick % 5400 == 2700 then
		if math.random(1,2) == 1 then biter_attack_event() end
    end
end

--[[
    int gameTick
    position {x,y}
]]--
function add_biter_spawn(gameTick, position)
    table.insert(biter_spawn_schedule, {gameTick, position})
end


Event.add(defines.events.on_tick, on_tick)


return {
    add_biter_spawn = add_biter_spawn
}