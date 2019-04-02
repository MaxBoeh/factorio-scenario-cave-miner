local config = require "maps.cave_miner.config"

local function heal_rocks()
	local healing_amount = config.rock_healing
	for key, rock in pairs(global.damaged_rocks) do
		if rock.last_damage + 300 < game.tick then
			if rock.entity.valid then
				rock.entity.health = rock.entity.health + healing_amount[rock.entity.name]
				if rock.entity.prototype.max_health == rock.entity.health then global.damaged_rocks[key] = nil end
			else
				global.damaged_rocks[key] = nil
			end
		end
	end
end

local function on_tick(event)	
	if game.tick % 960 == 0 then
		heal_rocks()
	end
end

Event.add(defines.events.on_tick, on_tick)	