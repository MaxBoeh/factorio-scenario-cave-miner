
local player_hunger_stages = {}
for x = 1, 200, 1 do
	if x <= 200 then player_hunger_stages[x] = "Obese" end						
	if x <= 179 then player_hunger_stages[x] = "Stuffed" end
	if x <= 150 then player_hunger_stages[x] = "Bloated" end
	if x <= 130 then player_hunger_stages[x] = "Sated" end
	if x <= 110 then player_hunger_stages[x] = "Well Fed" end
	if x <= 89 then player_hunger_stages[x] = "Nourished" end			
	if x <= 70 then player_hunger_stages[x] = "Hungry" end
	if x <= 35 then player_hunger_stages[x] = "Starving" end			
end

local player_hunger_color_list = {}
for x = 1, 50, 1 do
	player_hunger_color_list[x] = 		{r = 0.5 + x*0.01, g = x*0.01, b = x*0.005}
	player_hunger_color_list[50+x] = {r = 1 - x*0.02, g = 0.5 + x*0.01, b = 0.25}
	player_hunger_color_list[100+x] = {r = 0 + x*0.02, g = 1 - x*0.01, b = 0.25}
	player_hunger_color_list[150+x] = {r = 1 - x*0.01, g = 0.5 - x*0.01, b = 0.25 - x*0.005}
end

local player_hunger_buff = {}
local buff_top_value = 0.70		
for x = 1, 200, 1 do
	player_hunger_buff[x] = buff_top_value
end
local y = 1
for x = 89, 1, -1 do			
	player_hunger_buff[x] = buff_top_value - y * 0.015
	y = y + 1
end
local y = 1		
for x = 111, 200, 1 do			
	player_hunger_buff[x] = buff_top_value - y * 0.015
	y = y + 1
end

return {
    player_hunger_spawn_value = 80,
    player_hunger_fish_food_value = 10,
    player_hunger_stages = player_hunger_stages,
    player_hunger_color_list = player_hunger_color_list,
    player_hunger_buff = player_hunger_buff,

	map_info = [[
Delve deep for greater treasures, but also face increased dangers.
Mining productivity research, will overhaul your mining equipment,
reinforcing your pickaxe as well as increasing the size of your backpack.

Breaking rocks is exhausting and might make you hungry.
So don´t forget to eat some fish once in a while to stay well fed.
But be careful, eating too much might have it´s consequences too.

As you dig, you will encounter black bedrock that is just too solid for your pickaxe.
Some explosives could even break through the impassable dark rock.
All they need is a container and a well aimed shot.

Darkness is a hazard in the mines, stay near your lamps...
]],
	
    darkness_messages = {
        "Something is lurking in the dark...",
        "A shadow moves. I doubt it is friendly...",
        "The silence grows louder...",
        "Trust not your eyes. They are useless in the dark.",
        "The darkness hides only death. Turn back now.",
        "You hear noises...",
        "They chitter as if laughing, hungry for their next foolish meal...",
        "Despite what the radars tell you, it is not safe here...",
        "The shadows are moving...",
        "You feel like, something is watching you...",
        "You feel like, something is watching you...",
        "You feel like, something is watching you...",
    },

    map = {
        shop_block_range = 125,
        infinity_chest_block_range = 40,
        infinity_chest_raffle_config = {
            -- a list with all possible chest contents will be created from this config (raffle table)
            -- _weight_: how many times this line will be added to the raffle table
            -- Every N _seconds_ items in the chest will be filled up to _amount_
            { weight = 10, amount = 6, seconds = 2, name = "wood" },
            { weight = 8, amount = 6, seconds = 2, name = "iron-ore" },
            { weight = 8, amount = 6, seconds = 2, name = "copper-ore" },
            { weight = 8, amount = 6, seconds = 2, name = "coal" },
            { weight = 6, amount = 6, seconds = 3, name = "uranium-ore" },
            { weight = 6, amount = 6, seconds = 3, name = "iron-plate" },
            { weight = 6, amount = 6, seconds = 3, name = "copper-plate" },
            { weight = 4, amount = 1, seconds = 3, name = "steel-plate" },

            { weight = 4, amount = 4, seconds = 8, name = "transport-belt" },
            { weight = 4, amount = 2, seconds = 10, name = "inserter" },
            { weight = 3, amount = 2, seconds = 10, name = "small-lamp" },
            { weight = 4, amount = 2, seconds = 3, name = "electronic-circuit" },
            { weight = 3, amount = 2, seconds = 3, name = "advanced-circuit" },
            { weight = 2, amount = 1, seconds = 10, name = "processing-unit" },
            { weight = 2, amount = 2, seconds = 10, name = "coin" },
            { weight = 2, amount = 1, seconds = 10, name = "solid-fuel" },
            { weight = 2, amount = 1, seconds = 30, name = "nuclear-fuel" },

            { weight = 1, amount = 2, seconds = 15, name = "logistic-science-pack" }, -- green
            { weight = 1, amount = 1, seconds = 30, name = "military-science-pack" }, -- black
            { weight = 1, amount = 1, seconds = 30, name = "chemical-science-pack" }, -- blue
            { weight = 1, amount = 1, seconds = 40, name = "production-science-pack" }, -- purple
            { weight = 1, amount = 1, seconds = 50, name = "utility-science-pack" }, -- yellow
        }
    },

    rock_healing = {
        ["rock-big"] = 4,
        ["sand-rock-big"] = 4,
        ["rock-huge"] = 16
    }
}