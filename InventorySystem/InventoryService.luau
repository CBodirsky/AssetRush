--[[
InventoryService.lua
Server-side inventory system that manages per-player item storage.
Slot based inventory limits
Tracking of item metadata (purchase price, rarity, timestamp)
Server-authoritative add/remove operations
Automatic initialization and cleanup on player join/leave
Designed to be extended for future features such as player housing upgrades and inventory expansion
]]

local Players = game:GetService("Players")

local InventoryService = {}

-- Per-player inventories: [userId] = { inventory table }
local Inventories = {}

-- Slot limits: [userId] = number of max slots (default = 5)
local MaxSlots = {}

local DEFAULT_SLOTS = 5

-- Initialize inventory for player
local function ensureInventory(player)
	local userId = player.UserId
	if not Inventories[userId] then
		Inventories[userId] = {}
		MaxSlots[userId] = DEFAULT_SLOTS
	end
end

function InventoryService:AddItem(player, itemId, purchasePrice, isRare)
	ensureInventory(player)

	local inventory = Inventories[player.UserId]
	local max = MaxSlots[player.UserId]

	if #inventory >= max then
		return false, "Inventory full"
	end

	--print("[AddItem] Inserting into:", player.UserId)
	--print("[AddItem] Before:", inventory)

	table.insert(inventory, {
		itemId = itemId,
		purchasePrice = purchasePrice,
		isRare = isRare or false,
		acquired = os.time()
	})

	--print("[AddItem] After:", inventory)
	return true
end

function InventoryService:RemoveItem(player, itemId, price)
	local inventory = Inventories[player.UserId]
	if not inventory then return false, "No inventory" end

	for i, entry in ipairs(inventory) do
		if entry.itemId == itemId then
			table.remove(inventory, i)
			-- Here you could increment player funds, log the sale, etc.
			return true
		end
	end

	return false, "Item not found"
end

function InventoryService:GetInventory(player)
	--print("[InventoryService:GetInventory] For", player.Name, "?", Inventories[player.UserId])

	ensureInventory(player)
	return Inventories[player.UserId]
end

function InventoryService:GetUsedSlots(player)
	local inv = Inventories[player.UserId]
	return inv and #inv or 0
end

function InventoryService:GetMaxSlots(player)
	return MaxSlots[player.UserId] or DEFAULT_SLOTS
end

function InventoryService:SetMaxSlots(player, slots)
	MaxSlots[player.UserId] = math.max(slots, 1)
end

-- Optional: Cleanup on player leave
Players.PlayerRemoving:Connect(function(player)
	local userId = player.UserId
	Inventories[userId] = nil
	MaxSlots[userId] = nil
end)

Players.PlayerAdded:Connect(function(player)
	ensureInventory(player)
end)

return InventoryService
