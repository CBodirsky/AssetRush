local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InventoryService = require(game.ServerScriptService.InventorySystem.InventoryService)
local ItemDefinitions = require(game.ServerScriptService.MarketSystem.ItemDefinitionsList)

local GetInventory = ReplicatedStorage.GetInventory
GetInventory.Name = "GetInventory"
GetInventory.Parent = ReplicatedStorage

GetInventory.OnServerInvoke = function(player)
	local rawInventory = InventoryService:GetInventory(player)
	local normalized = {}

	for _, item in pairs(rawInventory) do
		local itemId = item.itemId
		local def = ItemDefinitions[itemId]
		if def then
			table.insert(normalized, {
				itemId = itemId,
				DisplayName = def.DisplayName,
				Price = item.purchasePrice or math.random(def.MinPrice, def.MaxPrice),
				--isRare = def.MaxPrice > 50,
				TimerGroup = def.TimerGroup,
			})
		else
			warn(" Unknown itemId in inventory:", itemId)
		end
	end

	return {
		Items = normalized,
		MaxSlots = InventoryService:GetMaxSlots(player)
	}
end
