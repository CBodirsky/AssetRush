--[[
PriceSeedStrategy.lua
Generates deterministic price values for items based on:
A shared epoch timestamp
The itemId (hashed)
A selected pricing strategy (uniform, bipolar, steady) that creates variety in market behavior.
This ensures all servers share identical pricing and timing without needing cross-server communication.
]]

local PriceSeedStrategy = {}

local function getSeed(epoch, itemId)
	local itemHash = 0
	for i = 1, #itemId do
		itemHash += string.byte(itemId, i)
	end
	return epoch + itemHash
end

function PriceSeedStrategy:Generate(min, max, epoch, itemId, strategy)
	assert(typeof(min) == "number" and typeof(max) == "number", "Invalid min/max")
	assert(typeof(epoch) == "number", "Epoch required")
	assert(typeof(itemId) == "string", "Item ID required")

	local seed = getSeed(epoch, itemId)
	local rng = Random.new(seed)
	strategy = strategy or "default"
	
	if strategy == "uniform" then
	return rng:NextNumber(min, max)
	
	-- Provides extreme swings in range
	elseif strategy == "bipolar" then
		local raw = rng:NextNumber(0,1)
		local bipolar = 0.5 + 0.5 * math.sin((raw - 0.5) * math.pi)
		return min + (max - min) * bipolar
	
	
	--Provides steady values near middle of range
	elseif strategy == "steady" then
		local raw = rng:NextNumber(0,1)
		local steady = 	0.5 + 0.5 * math.cos((raw - 0.5) * math.pi)
		return min + (max - min) * steady
	
	--Typo or not created strategy
	else
		warn("Unkown price strategy", strategy)
		return rng:NextNumber(min,max)
	end
	
end

return PriceSeedStrategy