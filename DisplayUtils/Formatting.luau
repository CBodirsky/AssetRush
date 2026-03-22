--Formats numbers with suffixes and dollar signs. Used across all parts of the game.

local Formatting = {}

-- Adds commas to numbers (e.g. 1234567 ? "1,234,567")
local function addCommas(n)
	local s = tostring(n)
	local formatted = s:reverse():gsub("(%d%d%d)", "%1,"):reverse()
	if s:len() % 3 == 0 then
		formatted = formatted:sub(2)
	end
	return formatted
end

-- Suffixes for large numbers
local suffixes = {
	{1e33, "D"},   -- Decillion
	{1e30, "N"},   -- Nonillion
	{1e27, "O"},   -- Octillion
	{1e24, "S"},   -- Septillion
	{1e21, "Qd"},  -- Sextillion
	{1e18, "Qt"},  -- Quintillion
	{1e15, "Qa"},  -- Quadrillion
	{1e12, "T"},   -- Trillion
	{1e9,  "B"},   -- Billion
	{1e6,  "M"},   -- Million
}

function Formatting.FormatMoney(amount)
	return "$" .. addCommas(math.floor(amount + 0.5))
end

function Formatting.FormatScaledMoney(amount)
	for _, pair in ipairs(suffixes) do
		local limit, suffix = unpack(pair)
		if amount >= limit then
			local scaled = amount / limit
			local rounded = math.floor(scaled * 1000 + 0.5) / 1000  -- 3 decimal places
			return "$" .. tostring(rounded) .. suffix
		end
	end

	return Formatting.FormatMoney(amount)
end

return Formatting
