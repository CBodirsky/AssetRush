--[[
PlayerManager.lua
Player lifecycle and data management system, inheritted from a tycoon game framework.
DataStore persistence, Leaderstats setup, Inventory integration, Gamepass checks. 
]]

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local PlayerData = DataStoreService:GetDataStore("PlayerData")
local MarketplaceService = game:GetService("MarketplaceService")
local Gamepasses = require(script.Parent.Components.Gamepasses)


local function Reconcile(source, template)
	for k, v in pairs(template) do
		if not source[k] then
			source[k] = v
		end
	end
	return source
end

local function LeaderboardSetup(value)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"

	local money = Instance.new("IntValue")
	money.Name = "Money"
	money.Value = value
	money.Parent = leaderstats

	local rebirthCount = Instance.new("IntValue")
	rebirthCount.Name = "Rebirths"
	rebirthCount.Value = value
	rebirthCount.Parent = leaderstats

	return leaderstats
end

local function LoadData(player)
	local success, result = pcall(function()
		return PlayerData:GetAsync(player.UserId)
	end)
	if not success then
		warn(result)
	end
	return success, result
end

local function SaveData(player, data)
	local success, result = pcall(function()
		PlayerData:SetAsync(player.UserId, data)
	end)
	if not success then
		warn(result)
	end
	return success
end

local sessionData = {}

local playerAdded = Instance.new("BindableEvent")
local playerRemoving = Instance.new("BindableEvent")

local PlayerManager = {}

PlayerManager.PlayerAdded = playerAdded.Event
PlayerManager.PlayerRemoving = playerRemoving.Event

game:GetService("Players").PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		character:FindFirstChild("Humanoid").WalkSpeed = 32
	end)
end)

function PlayerManager.Start()
	for _, player in ipairs(Players:GetPlayers()) do
		coroutine.wrap(PlayerManager.OnPlayerAdded)(player) 
	end

	Players.PlayerAdded:Connect(PlayerManager.OnPlayerAdded)
	Players.PlayerRemoving:Connect(PlayerManager.OnPlayerRemoving)

	game:BindToClose(PlayerManager.OnClose)
end

function PlayerManager.OnPlayerAdded(player)
	player.CharacterAdded:Connect(function(character)
		PlayerManager.OnCharacterAdded(player, character)
	end)

	local success, data = LoadData(player)
	if game:GetService("RunService"):IsStudio() then
		data = nil -- force "new player" state on every Studio test
	end

	sessionData[player.UserId] = Reconcile(
		
		if success and data then data else {},
		{
			Money = 10,
			UnlockIds = {},
			RebirthCount = 0,
		}
	)

	local leaderstats = LeaderboardSetup(PlayerManager.GetMoney(player))
	leaderstats.Rebirths.Value = sessionData[player.UserId].RebirthCount
	leaderstats.Parent = player

	playerAdded:Fire(player)
	print(sessionData[player.UserId])
end

function PlayerManager.OnCharacterAdded(player, character)
	local humanoid = character:FindFirstChild("Humanoid")
	if humanoid then
		humanoid.Died:Connect(function()
			wait(3)
			player:LoadCharacter()
		end)
	end
end

function PlayerManager.GetMoney(player)
	return sessionData[player.UserId].Money
end

function PlayerManager.SetMoney(player, value)
	if value then
		sessionData[player.UserId].Money = value

		local leaderstats = player:FindFirstChild("leaderstats")
		if leaderstats then
			local money = leaderstats:FindFirstChild("Money")
			if money then
				sessionData[player.UserId].Money = value
				money.Value = value
			end
		end
	end
end

function PlayerManager:AttemptBuy(player, itemId, price)
	local data = sessionData[player.UserId]
	if not data then return false end

	if data.Money >= price then
		data.Money -= price
		PlayerManager.SetMoney(player, data.Money)

		-- Add to inventory (you’ll build this)
		PlayerManager:AddItemToInventory(player, itemId, price)
		return true
	else
		return false -- Not enough cash!
	end
end

function PlayerManager:AttemptSell(player, itemId, salePrice)
	local data = sessionData[player.UserId]
	if not data then return false end

	if PlayerManager:RemoveItemFromInventory(player, itemId) then
		data.Money += salePrice
		PlayerManager.SetMoney(player, data.Money)
		return true
	end

	return false -- Didn't have the item
end

function PlayerManager:AddItemToInventory(player, itemId, cost)
	local data = sessionData[player.UserId]
	data.Inventory = data.Inventory or {}

	table.insert(data.Inventory, {
		itemId = itemId,
		purchasePrice = cost
	})
end

function PlayerManager:RemoveItemFromInventory(player, itemId)
	local data = sessionData[player.UserId]
	data.Inventory = data.Inventory or {}

	for i, item in ipairs(data.Inventory) do
		if item.itemId == itemId then
			table.remove(data.Inventory, i)
			return true
		end
	end

	return false
end

function PlayerManager:GetRebirthCount(player)
	if player then
		return sessionData[player.UserId].RebirthCount
	else
		error("Player object is nil!")
	end
end

function PlayerManager:SetRebirthCount(player, value)
	if value then
		sessionData[player.UserId].RebirthCount = value

		local leaderstats = player:FindFirstChild("leaderstats")
		if leaderstats then
			local rebirthCount = leaderstats:FindFirstChild("Rebirths")
			if rebirthCount then
				rebirthCount.Value = value
			end
		end
	end
end

function PlayerManager.AddUnlockId(player, id)
	local data = sessionData[player.UserId]

	if not table.find(data.UnlockIds, id) then
		table.insert(data.UnlockIds, id)
	end
end

function PlayerManager.GetUnlockIds(player)
	return sessionData[player.UserId].UnlockIds
end

function PlayerManager.ClearUnlockIds(player)
	local data = sessionData[player.UserId]
	table.clear(data.UnlockIds)
end

function PlayerManager.OnPlayerRemoving(player)
	SaveData(player, sessionData[player.UserId])
	playerRemoving:Fire(player)
end

function PlayerManager.OnClose()
	for _, player in ipairs(Players:GetPlayers()) do
		PlayerManager.OnPlayerRemoving(player)
	end
end

--Activate gamepass script below when ready
--Also activate the related line in PlayerManager:OnPlayerAdded
--Also modify the multiplier line in Collector script if using a multiplier gamepass

function PlayerManager:HasGamePass(player, gpId)
	
	--return false --Remove after testing and unable line below!!
	return MarketplaceService:UserOwnsGamePassAsync(player.UserId, gpId)
end


return PlayerManager
