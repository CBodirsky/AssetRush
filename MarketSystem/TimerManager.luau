--[[
TimerManager.lua
manages epoch aligned timers for each item category. At the end of each timer,
triggers deterministic price regeneration via ItemManager and updates TradeStand
displays. Provides time remianing queries for UI elements.
]]

local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ItemManager = require(script.Parent.ItemManager)
local TimerIntervals = require(script.Parent.TimerIntervals)

local TimerManager = {}

-- Keep track of the last epoch-aligned tick
local lastEpochTick = {}

-- Updates PriceLabel for all TradeStands
local function updateTradeStandDisplays()
	for _, stand in pairs(Workspace:GetChildren()) do
		if not (stand:IsA("Model") and stand.Name:match("TradeStand$")) then
			continue
		end

		local itemId = stand.Name:match("^(.*)TradeStand$")
		local priceLabel = stand:FindFirstChild("PriceLabel", true)

		if itemId and priceLabel then
			local price = ItemManager:GetCurrentPrice(itemId)
			if price then
				priceLabel.Text = "$" .. tostring(math.floor(price + 0.5))
			end
		end
	end
end

RunService.Heartbeat:Connect(function()
	local now = os.time()

	for groupId, interval in pairs(TimerIntervals) do
		local currentTick = now - (now % interval)

		if lastEpochTick[groupId] ~= currentTick then
			lastEpochTick[groupId] = currentTick
			
			--Add below back if timing issues
			--print("Epoch-aligned tick for", groupId, "?", currentTick)
			ItemManager:GenerateGroupPrices(groupId)
			updateTradeStandDisplays()
		end
	end
end)

function TimerManager:GetTimeRemaining(groupId)
	local interval = TimerIntervals[groupId]
	local lastTick = lastEpochTick[groupId]

	if not interval then
		warn("Unknown timer group:", groupId)
		return 0
	end

	if not lastTick then
		local now = os.time()
		local currentTick = now - (now % interval)
		local nextTick = currentTick + interval
		return math.max(0, nextTick - now)
	end

	local now = os.time()
	local nextTick = lastTick + interval
	return math.max(0, nextTick - now)
end

return TimerManager
