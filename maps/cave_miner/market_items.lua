local items = {}
items.spawn = {
	{price = {}, offer = {type = 'nothing', effect_description = 'Deposit Coins'}},
	{price = {}, offer = {type = 'nothing', effect_description = 'Withdraw Coins - 1% Bank Fee'}},
	{price = {}, offer = {type = 'nothing', effect_description = 'Show Account Balance'}},
	{price = {{"coin", 2}}, offer = {type = 'give-item', item = 'raw-fish', count = 10}},
	{price = {{"coin", 50}}, offer = {type = 'give-item', item = 'light-armor', count = 1}},
	{price = {{"coin", 100}}, offer = {type = 'give-item', item = 'heavy-armor', count = 1}},
	{price = {{"coin", 50}}, offer = {type = 'give-item', item = 'shotgun', count = 1}},
	{price = {{"coin", 50}}, offer = {type = 'give-item', item = 'submachine-gun', count = 1}},
	{price = {{"coin", 5}}, offer = {type = 'give-item', item = 'rail', count = 4}},
	{price = {{"coin", 5}}, offer = {type = 'give-item', item = 'rail-signal', count = 2}},
	{price = {{"coin", 5}}, offer = {type = 'give-item', item = 'rail-chain-signal', count = 2}},
	{price = {{"coin", 10}}, offer = {type = 'give-item', item = 'train-stop'}},
	{price = {{"coin", 94}}, offer = {type = 'give-item', item = 'locomotive'}},
	{price = {{"coin", 35}}, offer = {type = 'give-item', item = 'cargo-wagon'}},
	{price = {{"coin", 1}}, offer = {type = 'give-item', item = 'red-wire', count = 1}},
	{price = {{"coin", 1}}, offer = {type = 'give-item', item = 'green-wire', count = 1}},
	{price = {{"coin", 4}}, offer = {type = 'give-item', item = 'decider-combinator'}},
	{price = {{"coin", 4}}, offer = {type = 'give-item', item = 'arithmetic-combinator'}},
	{price = {{"coin", 2}}, offer = {type = 'give-item', item = 'constant-combinator'}},
	{price = {{"coin", 4}}, offer = {type = 'give-item', item = 'programmable-speaker'}},
	{price = {{"coin", 2}}, offer = {type = 'give-item', item = 'small-lamp'}},
	{price = {{"coin", 2}}, offer = {type = 'give-item', item = 'firearm-magazine'}},
	{price = {{"coin", 4}}, offer = {type = 'give-item', item = 'piercing-rounds-magazine'}},
	{price = {{"coin", 2}}, offer = {type = 'give-item', item = 'shotgun-shell'}},
	{price = {{"coin", 4}}, offer = {type = 'give-item', item = 'piercing-shotgun-shell'}},
	{price = {{"coin", 3}}, offer = {type = 'give-item', item = 'grenade'}},
	{price = {{"coin", 2}}, offer = {type = 'give-item', item = 'land-mine'}},
	{price = {{"coin", 1}}, offer = {type = 'give-item', item = 'explosives', count = 2}},	
	{price = {{"coin", 40}}, offer = {type = 'give-item', item = 'cliff-explosives'}},
	{price = {{"coin", 5}}, offer = {type = 'give-item', item = 'wood', count = 25}},
	{price = {{"coin", 5}}, offer = {type = 'give-item', item = 'iron-ore', count = 25}},
	{price = {{"coin", 5}}, offer = {type = 'give-item', item = 'copper-ore', count = 25}},
	{price = {{"coin", 5}}, offer = {type = 'give-item', item = 'stone', count = 25}},
	{price = {{"coin", 5}}, offer = {type = 'give-item', item = 'coal', count = 25}},	
	{price = {{"coin", 5}}, offer = {type = 'give-item', item = 'uranium-ore', count = 20}},
	{price = {{"raw-fish", 10}}, offer = {type = 'give-item', item = 'coin', count = 2}},
	{price = {{'wood', 25}}, offer = {type = 'give-item', item = "coin", count = 2}},	
	{price = {{'iron-ore', 25}}, offer = {type = 'give-item', item = "coin", count = 2}},
	{price = {{'uranium-ore', 20}}, offer = {type = 'give-item', item = "coin", count = 2}},
	{price = {{'copper-ore', 25}}, offer = {type = 'give-item', item = "coin", count = 2}},
	{price = {{'stone', 25}}, offer = {type = 'give-item', item = "coin", count = 2}},
	{price = {{'coal', 25}}, offer = {type = 'give-item', item = "coin", count = 2}}
}
return items