-- =============================================================================
-- data define
-- =============================================================================
-- inner data
local BASE = {
	["0"] = 0,
	["1"] = 1,
	["2"] = 2,
	["3"] = 3,
	["4"] = 4,
	["5"] = 5,
	["6"] = 6,
	["7"] = 7,
	["8"] = 8,
	["9"] = 9,
	["A"] = 10,
	["B"] = 11,
	["C"] = 12,
	["D"] = 13,
	["E"] = 14,
	["F"] = 15,
}

-- =============================================================================
-- function define
-- =============================================================================
local function base_check(str, base)
	for bit in str:gmatch("%w") do
		if not ( BASE[bit] and ( BASE[bit] < base)) then
			local info =string.format(
				"error, input-bit %s, base %s",
				str, base)
			return nil, info
		end
	end
	return true
end


--[[
@str	:number input
@base	:the number base
@return :bin-str
--]]
local function _input_convert(str, base)
	local obase = "obase=2;"
	
	if base == 10 then
		ibase = ""
	else
		ibase = string.format("ibase=%d;", base)
	end

	local cmd = string.format('echo "%s%s%s" | bc', ibase, obase, str)

	local binstr = io.popen(cmd):read("*all"):gsub("%c", "")

	local ret = binstr:match("^%d(.*)")
	if not ret then
		os.exit(1)
	end

	return binstr
end

local function input_convert(str, base)
	local ret, info = base_check(str, base)
	if not ret then
		error(info)
	end

	return _input_convert(str, base)
end

-- convert binstr to bits-table
local function binstr_to_table(binstr, width)
	local bits = {}
	-- prefix 0
	if #binstr < width then
		local n = width - #binstr
		local prefix = string.rep("0", n)
		binstr = string.format("%s%s", prefix, binstr)
	end

	local len = #binstr
	for bit in binstr:gmatch("%d") do
		bits[len] = bit
		len = len - 1
	end

	return bits
end



return {
	base_check = base_check,
	input_convert   = input_convert,
	_input_convert  = _input_convert,
	binstr_to_table = binstr_to_table,
}
