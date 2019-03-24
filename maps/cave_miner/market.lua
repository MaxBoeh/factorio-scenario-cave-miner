
local bank_messages = {
	"Coinbank. The only choice.",
	"Smart miners use Coinbank!",
	"Coinbank, because inventory space matters!"
}
	
local function on_market_item_purchased(event)	
	local player = game.players[event.player_index]	
	local market = event.market
	local offer_index = event.offer_index
	local count = event.count
	local offers = market.get_market_items()	
	local bought_offer = offers[offer_index].offer	
	if bought_offer.type ~= "nothing" then return end
	if not global.fish_bank then global.fish_bank = {} end
	if not global.fish_bank[player.name] then global.fish_bank[player.name] = 0 end
	
	if offer_index == 1 then
		local fish_removed = player.remove_item({name = "coin", count = 999999})
		if fish_removed == 0 then return end
		global.fish_bank[player.name] = global.fish_bank[player.name] + fish_removed				
		player.print(fish_removed .. " Coins deposited into your account. Your balance is " .. global.fish_bank[player.name] .. ".", {r=0.10, g=0.75, b=0.5})
		player.print(bank_messages[math.random(1,#bank_messages)], { r=0.77, g=0.77, b=0.77})
		player.surface.create_entity({name = "flying-text", position = player.position, text = tostring(fish_removed .. " Coins deposited"), color = {r=0.10, g=0.75, b=0.5}})
	end
	
	if offer_index == 2 then
		if global.fish_bank[player.name] == 0 then
			player.print("No coins in your Bank account :(", { r=0.10, g=0.75, b=0.5})
			return
		end
		
		local requested_withdraw_amount = 500
		local fee = 10		
		if global.fish_bank[player.name] < requested_withdraw_amount + fee then		
			fee = math.ceil(global.fish_bank[player.name] * 0.01, 0)
			if global.fish_bank[player.name] < 10 then fee = 0 end
			requested_withdraw_amount = global.fish_bank[player.name] - fee
		end			
		local fish_withdrawn = player.insert({name = "coin", count = requested_withdraw_amount})
		if fish_withdrawn ~= requested_withdraw_amount then
			player.remove_item({name = "coin", count = fish_withdrawn})
			return
		end								
		global.fish_bank[player.name] = global.fish_bank[player.name] - (fish_withdrawn + fee)
		player.print(fish_withdrawn .. " Coins withdrawn from your account. Your balance is " .. global.fish_bank[player.name] .. ".", { r=0.10, g=0.75, b=0.5})
		player.print(bank_messages[math.random(1,#bank_messages)], { r=0.77, g=0.77, b=0.77})
		player.surface.create_entity({name = "flying-text", position = player.position, text = tostring(fish_withdrawn .. " Coins withdrawn"), color = {r=0.10, g=0.75, b=0.5}})
	end	
	
	if offer_index == 3 then						
		player.print("Your balance is " .. global.fish_bank[player.name] .. " Coins.", { r=0.10, g=0.75, b=0.5})
	end
end

Event.add(defines.events.on_market_item_purchased, on_market_item_purchased)