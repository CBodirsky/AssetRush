--local PlayerManager = require(script.Parent.PlayerManager)
--local MarketPlaceService = game:GetService("MarketplaceService")
--local Players = game:GetService("Players")

--local products = {
--	[0] = function(player) --Add dev product ID in place of zero
--		PlayerManager.SetMoney(player, PlayerManager.GetMoney(player) + 1000) -- Dev product to add $1000 once. Change accordingly
--		return true
--	end,
--}

--MarketPlaceService.ProcessReceipt = function(info)
--	local player = Players:GetPlayerByUserId(info.PlayerId)
--	if not player then
--		return Enum.ProductPurchaseDecision.NotProcessedYet
--	end
	
--	local success, result = pcall(products[info.ProductId], player)
--	if not success or not result then
--		warn ("Error for Product ".. result)
--		return Enum.ProductPurchaseDecision.NotProcessedYet
--	end
--	return Enum.ProductPurchaseDecision.PurchaseGranted
--end