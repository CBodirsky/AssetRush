--[[
InjectModes.lua
Responsible for spawning item models into TradeStand locations and updating their UI elements.
The data-driven ItemDefinitions table determines which models to place and related function.
This also listens for price changes and updates the UI accordingly.
]]

local TweenService = game:GetService("TweenService") 
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local ServerScriptService = game:GetService("ServerScriptService")

local ItemManager = require(ServerScriptService.MarketSystem.ItemManager)
local ItemDefinitions = require(ServerScriptService.MarketSystem.ItemDefinitionsList)
local TradeItemsFolder = ReplicatedStorage:WaitForChild("TradeItems")

local PanelBuilder = require(script.Parent.Parent.DisplayUtils.PanelBuilder)
local ItemDefinitions = require(script.Parent.Parent.MarketSystem.ItemDefinitionsList)

for itemId in pairs(ItemDefinitions) do
	PanelBuilder.Create(itemId)
end

local function extractItemId(name)
	return name:match("^(.*)TradeStand$")
end


-- Wait for prices to become available
local timeout = 5
local t = 0
repeat
	local price = ItemManager:GetCurrentPrice("Pencil") -- any known item ID
	if price then break end
	task.wait(0.1)
	t += 0.1
until t >= timeout

local ModelsFolder = ReplicatedStorage:WaitForChild("TradeItems")

local function flashPrice(label, newPrice, oldPrice)
	local direction = newPrice > oldPrice and "up" or "down"
	local flashColor = direction == "up"
		and Color3.fromRGB(0, 170, 0)
		or Color3.fromRGB(255, 0, 0)

	local original = label.TextColor3

	local tweenIn = TweenService:Create(label, TweenInfo.new(0.15), { TextColor3 = flashColor })
	local tweenOut = TweenService:Create(label, TweenInfo.new(0.25), { TextColor3 = original })

	tweenIn:Play()
	tweenIn.Completed:Once(function()
		tweenOut:Play()
	end)
end

for itemId, _ in pairs(ItemDefinitions) do
	local stationName = itemId .. "TradeStand"
	local station = Workspace:FindFirstChild(stationName)

	if station then
		local priceLabel = station:FindFirstChild("PriceLabel", true)
		if priceLabel and priceLabel:IsA("TextLabel") then
			local currentPrice = ItemManager:GetCurrentPrice(itemId)
			priceLabel.Text = "$" .. tostring(math.floor(currentPrice + 0.5))
			priceLabel:SetAttribute("LastPrice", currentPrice)

			-- Watch for price changes
			task.spawn(function()
				while true do
					task.wait(1)

					local newPrice = ItemManager:GetCurrentPrice(itemId)
					local oldPrice = priceLabel:GetAttribute("LastPrice")

					if newPrice and oldPrice and newPrice ~= oldPrice then
						priceLabel.Text = string.format("$%d",newPrice)
						flashPrice(priceLabel, newPrice, oldPrice)
						priceLabel:SetAttribute("LastPrice", newPrice)
					end
				end
			end)
		end
	end
end

for _, tradeStand in ipairs(Workspace:GetChildren()) do
    if tradeStand:IsA("Model") and tradeStand.Name:match("TradeStand$") then
    end
	if not tradeStand:IsA("Model") then continue end

	local itemId = extractItemId(tradeStand.Name)
	if not itemId then
--		warn("Could not extract itemId from TradeStand:", tradeStand.Name)
		continue
	end

	local itemDef = ItemDefinitions[itemId]
	if not itemDef then
		warn("No item definition for", itemId)
		continue
	end

	local modelTemplate = TradeItemsFolder:FindFirstChild(itemId)
	if not modelTemplate then
		warn("No model found for", itemId, "in ReplicatedStorage.TradeItems")
		continue
	end

	local itemHolder = tradeStand:FindFirstChild("ItemModel")
	if not itemHolder then
		warn("TradeStand missing 'ItemModel' container:", tradeStand.Name)
		continue
	end

	-- Don’t duplicate if already placed
	if #itemHolder:GetChildren() > 0 then
		continue
	end

	local model = modelTemplate:Clone()

	-- Ensure it has a PrimaryPart for positioning
	if not model.PrimaryPart then
		warn("Model for", itemId, "has no PrimaryPart set")
		continue
	end

	-- Offset + scale from definition, if any
	--local offset = itemDef.ModelOffset or CFrame.new()
	local scaleFactor = itemDef.ModelScale or 1

	model:SetPrimaryPartCFrame(itemHolder.CFrame)
	itemHolder.Transparency = 1

	-- Uniform scaling (optional)
	if scaleFactor ~= 1 then
		for _, part in pairs(model:GetDescendants()) do
			if part:IsA("BasePart") then
				part.Size *= scaleFactor
			end
		end
	end
	
	local nameLabel = tradeStand:FindFirstChild("NameLabel", true)
	if nameLabel and itemDef.DisplayName then
		nameLabel.Text = itemDef.DisplayName
	end
	
	print("Injecting price for", itemId, "?", ItemManager:GetCurrentPrice(itemId))

	local priceLabel = tradeStand:FindFirstChild("PriceLabel", true)
	if priceLabel and itemId then
		local price = ItemManager:GetCurrentPrice(itemId)
		--if price then
		--	priceLabel.Text = string.format("$%.2f", price)
		--end
	end

	model.Parent = itemHolder
	print("Inserted", itemId, "model into", tradeStand.Name)
end