-- inner data
local BASE = {
	-- string to number
	["0"] = 0,  ["1"] = 1,  ["2"] = 2,  ["3"] = 3,
	["4"] = 4,  ["5"] = 5,  ["6"] = 6,  ["7"] = 7,
	["8"] = 8,  ["9"] = 9,  ["A"] = 10, ["B"] = 11,
	["C"] = 12, ["D"] = 13, ["E"] = 14, ["F"] = 15,

	-- number to string
	[0] = "0",  [1] = "1",  [2] = "2",  [3] = "3",
	[4] = "4",  [5] = "5",  [6] = "6",  [7] = "7",
	[8] = "8",  [9] = "9",  [10] = "A", [11] = "B",
	[12] = "C", [13] = "D", [14] = "E", [15] = "F",
}

--[[
power_generator.
@return function power, call this function will get the next power number;
--]]
local function power(base)
	local p = nil
	local base = base

	return function()
		if not p then
			p = 1
		else
			p = p * base
		end
		return p
	end
end

local function checkbase(base)
	assert(math.type(base) == "integer", "base input expect integer")

	if (base >= 2) and (base <= 16) then
		return true
	else
		error("base input expect 2~16")
	end
end

local function checkbase_str(str, base)
	for bit in str:gmatch("%w") do
		if not ( BASE[bit] and ( BASE[bit] < base)) then
			local info =string.format(
				"error, input-bit %s, base %s",
				str, base)
			error(info)
		end
	end
	return true
end

local function todec(str, ibase)
	if ibase == 10 then
		return tonumber(str)
	end

	local temp = {}
	for bit in str:gmatch("%w") do
		table.insert(temp, 1, bit)
	end

	local dec = 0
	local power = power(ibase)

	for _, bit in ipairs(temp) do
		dec = dec + BASE[bit] * power()
	end
	
	return math.floor(dec)
end

-- read from last to first
local function fromdec(dec, obase)
	if obase == 10 then
		return tostring(dec)
	end

	local obase = obase
	local num = {}

	local function _frodec(dec)
		if dec == 0 then return end
		
		local m = math.fmod(dec, obase)
		local reset = math.floor(dec/ obase)

		table.insert(num, 1, m)
		_frodec(reset)
	end

	_frodec(dec)

	local str = {}

	for _, n in ipairs(num) do
		table.insert(str, BASE[n])
	end

	return table.concat(str)
end

local function convert(str, ibase, obase)
	-- input format
	ibase = tonumber(ibase)
	obase = tonumber(obase)
	str = string.upper(str)

	-- input check
	checkbase(ibase)
	checkbase(obase)
	checkbase_str(str, ibase)

	if ibase == obase then
		return str
	end

	-- convert
	return fromdec(todec(str, ibase), obase)
end

return {
	convert = convert,
	checkbase = checkbase,
	checkbase_str = checkbase_str,
}
