local base = require("base")

-- =============================================================================
-- constant define
-- =============================================================================
local constant = {
	BIN = "b", -- tag binary
	DEC = "d", -- tag decimal
	HEX = "h", -- tag hexdecimal
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

local function input_convert(str, ibase)
	return base.convert(str, ibase, 2)
end

local function output_convert(binstr, obase)
	return base.convert(binstr, 2, obase)
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

-- convert bits-table to binstr
local function table_to_binstr(bits_table, from, to)
	local from = from or 1
	local to = to or #bits_table

	local bits = {}
	
	local idx = from

	while idx <= to do
		table.insert(bits, 1, bits_table[idx])
		idx = idx + 1
	end

	return table.concat(bits)
end

--[[
@pattern
	a:b   from bit a to bit b
	a+b   same as a:(a+b)
	a     same as a:a or a+1
	a+    same as a
	a:    same as a:end
@return	from, to
--]]
local function parse_range(pattern)
	local i1, i2, o, b, e -- input1, input2, operator, begin, end
	i1, o, i2 = string.match(pattern,"(%d+)([+:])(%d+)")

	i1 = o and i1 or string.match(pattern,"(%d+)")
	i1 = tonumber(i1)

	if not o then
		-- set default pattern, same as b+1
		o = string.match(pattern, ".*([+:]).*") or "+"
	else
		i2 = tonumber(i2)
	end

	-- the minimum begin index is 1
	b = (not i1 or i1 < 0) and 1 or (i1 + 1)

	-- i2 always got value in here
	if o == "+" then
		i2 = i2 or 1
		e = i2 and (b + i2 - 1)
	elseif o == ":" then
		if i2 then
			e = i2 and (i2 + 1)
			if b > e then
				b, e = e, b
			end
		end
		-- else e == nil
	end

	return b, e
end

-- base expect get (b|d|h|2~16) case error will exit
local function parse_base(_base)
	local _base = string.lower(_base)
	local num = tonumber(_base)
	local info = nil

	if tonumber(num) then
		_base = num
	elseif constant.HEX == _base then
		_base = 16
	elseif constant.DEC == _base then
		_base = 10
	elseif constant.BIN == _base then
		_base = 2
	else
		info = string.format(
		"error base , expect get(b|d|h|2~16), got %s.\n",
		tostring(_base)
		)
		error(info)
	end

	-- if fail will exit
	base.checkbase(_base)

	return _base
end

return {
	parse_base = parse_base,
	parse_range = parse_range,
	binstr_to_table = binstr_to_table,
	table_to_binstr = table_to_binstr,

	-- base convert
	base_check = base.checkbase_str,
	input_convert   = input_convert,
	output_convert  = output_convert,
}
