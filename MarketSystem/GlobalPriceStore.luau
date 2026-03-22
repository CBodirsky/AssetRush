local DataStoreService = game:GetService("DataStoreService")
local PriceStore = DataStoreService:GetDataStore("GlobalItemPrices")

local GlobalPriceStore = {}

function GlobalPriceStore:Write(timerGroup, pricesTable)
	local key = "Prices_" .. timerGroup

	local success, err = pcall(function()
		PriceStore:SetAsync(key, pricesTable)
	end)

	if success then
		print(" Global write successful for", timerGroup)
	else
		warn(" Global write failed for", timerGroup, ":", err)
	end
end

function GlobalPriceStore:Read(timerGroup)
	local key = "Prices_" .. timerGroup

	local success, result = pcall(function()
		return PriceStore:GetAsync(key)
	end)

	if not success then
		warn("[GlobalPriceStore] Failed to read prices for", timerGroup, ":", result)
		return nil
	end

	return result or nil
end

return GlobalPriceStore