

local Event = require 'utils.event' 
local config = require "maps.cave_miner.config"

local chests = {}

local prototype_name = "cave-miner_infinity-chest"

local function add_chest(chest_entity, item_name, amount, ticks)
    table.insert(chests, {
        entity = chest_entity,
        item_name = item_name,
        amount = amount,
        ticks = ticks
    })
end

local function ensure_chest_content(chest_config)
    local inventory = chest_config.entity.get_inventory(1)
    local item_amount = inventory.get_item_count(chest_config.item_name);

    local amount_to_insert = chest_config.amount - item_amount
    if amount_to_insert > 0 then
        inventory.insert({
            name = chest_config.item_name,
            count = amount_to_insert
        })
    end
end

local function on_tick(event)
    if game.tick % 60 == 0 then
        for index=1,#chests,1 do
            local chest_config = chests[index]
            if game.tick % chest_config.ticks == 0 then
                ensure_chest_content(chest_config)
            end
        end
    end
end

Event.add(defines.events.on_tick, on_tick)	

return {
    add_chest = add_chest
}