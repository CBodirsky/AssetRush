local ItemDefinitions = require(script.Parent.ItemDefinitionsList)
local TimerIntervals = require(script.Parent.TimerIntervals)
local PreviousPrices = {}

local ItemManager = {}

local PricingData = {}

local function roundToTenth(value)
	return math.round(value * 10) / 10
end

local function hashString(str)
	local hash = 0
	for i = 1, #str do
		hash = (hash * 31 + string.byte(str, i)) % 1e9
	end
	return hash
end

-- Deterministic price generation using seed and no repeat
local function generatePrice(itemId, minPrice, maxPrice, epoch)
	local seed = epoch + hashString(itemId)
	local rng = Random.new(seed)
	local lastPrice = PreviousPrices[itemId]
	local price

	for _ = 1, 5 do
		local raw = rng:NextInteger(minPrice, maxPrice)
		if raw ~= lastPrice then
			price = raw
			break
		end
	end

	if not price and lastPrice then
		local step = 1
		price = (lastPrice + step <= maxPrice) and (lastPrice + step)
			or (lastPrice - step >= minPrice and lastPrice - step or lastPrice)
	end

	PreviousPrices[itemId] = price
	PricingData[itemId] = price
	return price
end

function ItemManager:GenerateGroupPrices(groupId)
	local interval = TimerIntervals[groupId]
	local now = os.time()
	local epoch = now - (now % interval) - interval
	--print(" [ItemManager] Prices generated deterministically for", groupId)
	--print(" Epoch:", epoch)

	for itemId, def in pairs(ItemDefinitions) do
		if def.TimerGroup == groupId then
			local price = generatePrice(itemId, def.MinPrice, def.MaxPrice, epoch)
		end
	end
end

function ItemManager:GetCurrentPrice(itemId)
	return PricingData[itemId]
end

return ItemManager
