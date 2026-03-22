--[[
TimerLock.lua (Prototype)
Early experiment for cross-server synchronization using MemoryStoreService and lock acquisition.
Ultimately replaced by deterministic pricing, but included for archival and historical interest.
]]


--local MemoryStoreService = game:GetService("MemoryStoreService")
--local LOCK_DURATION = 20 -- seconds
--local LOCK_MAP_NAME = "TimerLocks" -- Change if you want to test clean maps

--local TimerLock = {}

--function TimerLock:TryAcquireLock(groupName)
--	local key = "Lock_" .. groupName
--	local map = MemoryStoreService:GetSortedMap(LOCK_MAP_NAME)

--	local jobId = tostring(game.JobId) -- Ensures we always write a string

--	local success, result = pcall(function()
--		return map:SetAsync(key, jobId, LOCK_DURATION, false)
--	end)

--	if not success then
--		warn("[TimerLock] SetAsync failed for", groupName, ":", result)
--		return false
--	end

--	if result == nil then
--		print("[TimerLock] Acquired lock for", groupName, "by", jobId)
--		return true
--	elseif result == jobId then
--		print("[TimerLock] Already holding lock for", groupName)
--		return true
--	elseif typeof(result) ~= "string" then
--		warn("[TimerLock] Unexpected value found for", groupName, ":", result, "(type: " .. typeof(result) .. ")")
--		return false
--	else
--		print("[TimerLock] Lock already held by", result)
--		return false
--	end
--end

--return TimerLock
