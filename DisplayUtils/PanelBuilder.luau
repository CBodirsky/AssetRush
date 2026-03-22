--[[
PanelBuilder.lua
Responsible for constructing TradeStand models into the world based on ItemDefinitions. Handles:
Spawning and positioning of TradeStands
Injecting item models with orientation
Setting up name and price labels
Real-time price updates iwth visual flash feedback
This works alongside InjectModels
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local Formatting = require(script.Parent.Formatting)
local ItemManager = require(ServerScriptService.MarketSystem.ItemManager)
local ItemDefinitions = require(ServerScriptService.MarketSystem.ItemDefinitionsList)

local TradeStandsFolder = ReplicatedStorage:WaitForChild("TradeStands")

local PanelBuilder = {}

-- Visual feedback
local function flashPrice(label, newPrice, oldPrice)
	local flashColor = newPrice > oldPrice and Color3.fromRGB(100, 255, 100)  -- green (up)
		or Color3.fromRGB(255, 100, 100) -- red (down)

	local original = label.TextColor3
	local tweenIn = TweenService:Create(label, TweenInfo.new(0.15), { TextColor3 = flashColor })
	local tweenOut = TweenService:Create(label, TweenInfo.new(0.25), { TextColor3 = original })

	tweenIn:Play()
	tweenIn.Completed:Once(function() tweenOut:Play() end)
end


-- Main builder
function PanelBuilder.Create(itemId)
	local def = ItemDefinitions[itemId]
	if not def then
		warn("No definition for item:", itemId)
		return
	end

	local modelTemplate = TradeStandsFolder:FindFirstChild(def.ModelName or "TradeStand")
--	print("Looking for model:", def.ModelName or "TradeStand")
--	print("Found model:", modelTemplate)
	if not modelTemplate then
--		warn(" Missing model:", def.ModelName)
		return
	end

	local model = modelTemplate:Clone()
	model.Name = itemId .. "TradeStand"
	model:SetAttribute("ItemId", itemId)

local tsFolder = workspace:WaitForChild("TSLocations")
local categoryFolder = tsFolder:FindFirstChild(def.TimerGroup or "Misc")
	local spawnAnchor = categoryFolder and categoryFolder:FindFirstChild("TS_" .. itemId)
	if spawnAnchor and spawnAnchor:IsA("BasePart") then
		model:SetPrimaryPartCFrame(spawnAnchor.CFrame)

	else
		warn("No position or pivot for", itemId)
	end
	
	local TradeItems = ReplicatedStorage:WaitForChild("TradeItems")

	local category = def.TimerGroup
	local categoryFolder = TradeItems:FindFirstChild(category)

	if not categoryFolder then
		warn("TimerGroup folder not found:", category)
		return
	end

	local itemModel = categoryFolder:FindFirstChild(itemId)

	if itemModel then
		local visual = itemModel:Clone()
		local anchor = model:FindFirstChild("ItemModel", true)

		if anchor and visual.PrimaryPart then
			local orientation = def and def.Orientation or Vector3.new(0, 0, 0)

			local anchorCFrame = anchor.CFrame
			local rotatedCFrame = anchorCFrame
				* CFrame.Angles(
					math.rad(orientation.X),
					math.rad(orientation.Y),
					math.rad(orientation.Z)
				)
			
			visual:SetPrimaryPartCFrame(rotatedCFrame)
			visual.Parent = model
			anchor.Transparency = 1
		else
			warn("Missing ModelAnchor or PrimaryPart for", itemId)
		end
	else
		warn("No item model found for", itemId)
	end

	-- Label setup
	local nameLabel = model:FindFirstChild("NameLabel", true)
	local priceLabel = model:FindFirstChild("PriceLabel", true)

	local price = ItemManager:GetCurrentPrice(itemId) or 0
	if nameLabel then nameLabel.Text = def.DisplayName end
	if priceLabel then
		local lastPrice = ItemManager:GetCurrentPrice(itemId) or 0
		priceLabel.Text = Formatting.FormatScaledMoney(lastPrice)
		priceLabel:SetAttribute("LastPrice", lastPrice)

		task.spawn(function()
			while priceLabel and priceLabel.Parent do
				task.wait(1)
				local currentPrice = ItemManager:GetCurrentPrice(itemId)
				local oldPrice = priceLabel:GetAttribute("LastPrice")
				if currentPrice and oldPrice and currentPrice ~= oldPrice then
					priceLabel.Text = Formatting.FormatScaledMoney(currentPrice)

					priceLabel:SetAttribute("LastPrice", currentPrice)

					-- Optional flash effect per label (green for up, red for down)
					local flashColor = currentPrice > oldPrice and Color3.fromRGB(100, 255, 100)
						or Color3.fromRGB(255, 100, 100)
					local original = priceLabel.TextColor3

					local TweenService = game:GetService("TweenService")
					local tweenIn = TweenService:Create(priceLabel, TweenInfo.new(0.15), { TextColor3 = flashColor })
					local tweenOut = TweenService:Create(priceLabel, TweenInfo.new(0.25), { TextColor3 = original })

					tweenIn:Play()
					tweenIn.Completed:Wait()
					tweenOut:Play()
				end
			end
		end)
	end

	-- Drop into workspace
	model.Parent = workspace.TradeStands
	return model
end

return PanelBuilder
