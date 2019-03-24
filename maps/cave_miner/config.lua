
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
    }
}