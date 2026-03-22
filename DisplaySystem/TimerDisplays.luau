local Workspace = game:GetService("Workspace")
local ServerScriptService = game:GetService("ServerScriptService")

local TimerManager = require(ServerScriptService.MarketSystem.TimerManager)

local function extractGroupId(name)
	return name:match("^Timer[_](.+)")
end

while true do
	for _, model in pairs(Workspace:GetChildren()) do
		if not model:IsA("Model") then continue end
		local groupId = extractGroupId(model.Name)
		if not groupId then continue end

		local label = model:FindFirstChild("TimeLabel", true)
		if not label then
			warn(" No TimeLabel found for", model.Name)
			continue
		end

		local remaining = TimerManager:GetTimeRemaining(groupId)
		if remaining then
			local minutes = math.floor(remaining / 60)
			local seconds = remaining % 60
			label.Text = string.format("%02d:%02d", minutes, seconds)
		end
	end
	task.wait(1)
end