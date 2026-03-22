--[[
Tycoon.lua
Core tycoon frameowrk inherited from a template.
Spawn ownership and tycoon instancing (for player housing in the future)
Unlockable components via CollectionService tags
Player-specific state
Topic-based event routing for UI and unlocks
Structual foundation for the world, with custom systems layered on top.
]]

local CollectionService = game:GetService("CollectionService")
local template = game:GetService("ServerStorage").Template
local componentFolder = script.Parent.Components
local tycoonStorage = game:GetService("ServerStorage").TycoonStorage
local playerManager = require(script.Parent.PlayerManager)

local function NewModel(model, cframe)
	local newModel = model:Clone()
	newModel:SetPrimaryPartCFrame(cframe)
	newModel.Parent = workspace
	return newModel
end

local Tycoon = {}
Tycoon.__index = Tycoon

function Tycoon.new(player, spawnPoint)
	local self = setmetatable({}, Tycoon)
	self.Owner = player
	self.CurrentHouse = nil

	self._topicEvent = Instance.new("BindableEvent")
	self._spawn = spawnPoint
	return self
end

function Tycoon:Init()
	self.Model = NewModel(template, self._spawn.CFrame)
	self._spawn:SetAttribute("Occupied", true)
	self.Owner.RespawnLocation = self.Model.Spawn
	self.Owner:LoadCharacter()

	self:LockAll()
	self:LoadUnlocks()
	self:WaitForRebirth()
	self:WaitForHardReset()
	self:WaitForExit()
	self:Music()
end

function Tycoon:SetHouse(newHouseModel)
	-- Remove old house if it exists
	if self.CurrentHouse and self.CurrentHouse.Parent then
		self.CurrentHouse:Destroy()
	end

	-- Clone and place new house
	local clone = newHouseModel:Clone()
	clone.Parent = self.Model
	clone:SetPrimaryPartCFrame(newHouseModel:GetPrimaryPartCFrame()) -- or custom placement

	self.CurrentHouse = clone
end


function Tycoon:LoadUnlocks()
	for _, id in ipairs(playerManager.GetUnlockIds(self.Owner)) do
		self:PublishTopic("Button", id)
	end
end

function Tycoon:LockAll()
	for _, instance in ipairs(self.Model:GetDescendants()) do
		if CollectionService:HasTag(instance, "Unlockable") then
			self:Lock(instance)
		else
			self:AddComponents(instance)
		end
	end
end

function Tycoon:Lock(instance)
	instance.Parent = tycoonStorage
	self:CreateComponent(instance, componentFolder.Unlockable)
end

function Tycoon:Unlock(instance, id)
	playerManager.AddUnlockId(self.Owner, id)
	CollectionService:RemoveTag(instance, "Unlockable")
	self:AddComponents(instance)
	instance.Parent = self.Model
end

function Tycoon:AddComponents(instance)
	for _, tag in ipairs(CollectionService:GetTags(instance)) do
		local component = componentFolder:FindFirstChild(tag)
		if component then
			self:CreateComponent(instance, component)
		end
	end
end

function Tycoon:CreateComponent(instance, componentScript)
	local compModule = require(componentScript)
	local newComp = compModule.new(self, instance)
	newComp:Init()
end

function Tycoon:PublishTopic(topicName, ...)
	self._topicEvent:Fire(topicName, ...)
end

function Tycoon:SubscribeTopic(topicName, callback)
	local connection = self._topicEvent.Event:Connect(function(name, ...)
		if name == topicName then
			callback(...)
		end
	end)
	return connection
end

function Tycoon:WaitForExit()
	playerManager.PlayerRemoving:Connect(function(player)
		if self.Owner == player then
			self:Destroy()
		end
	end)
end

function Tycoon:Music()
	local music = game.Workspace:FindFirstChild("Music")
	if not music then
		music = Instance.new("Sound")
		music.SoundId = "rbxassetid://97491543385250"
		music.Looped = true
		music.Playing = true
		music.Volume = 0.1
		music.Name = "Music"
		music.Parent = game.Workspace
	end
end

function Tycoon:WaitForRebirth()
	self:SubscribeTopic("Button", function(id)
		if id == "Rebirth" then
			local owner = self.Owner
			local rebirthCount = playerManager:GetRebirthCount(owner) + 1
			playerManager:SetRebirthCount(owner, rebirthCount)

			local spawnPoint = self._spawn

			playerManager.ClearUnlockIds(owner)
			playerManager.SetMoney(owner, 0)
			self:Destroy()

			local tyc = Tycoon.new(owner, spawnPoint)
			tyc:Init()
		end
	end)
end

function Tycoon:WaitForHardReset()
	self:SubscribeTopic("Button", function(id)
		if id == "HardReset" then
			local spawnPoint = self._spawn 
			local owner = self.Owner

			playerManager.ClearUnlockIds(owner)
			playerManager.SetMoney(owner, 0)
			playerManager:SetRebirthCount(owner, 0)
			self:Destroy()

			local tyc = Tycoon.new(owner, spawnPoint)
			tyc:Init()
		end
	end)
end

function Tycoon:Destroy()
	self.Model:Destroy()
	self._spawn:SetAttribute("Occupied", false)
	self._topicEvent:Destroy()
end

return Tycoon
