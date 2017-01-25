-- =============================================================================
-- import
-- =============================================================================
local convert = require("convert")

-- =============================================================================
-- output
-- =============================================================================
local output = {
	-- inner bitmap
	data = nil,
	
	-- outputbase
	base = 2,
	
	-- range
	from = nil,
	to   = nil,

	-- style flags
	gap = 4,
	sep = " ",
	islist = false,  -- if display with sheet
}
-- private function--------------------
local function reverse(_table)
	if type(_table) ~= "table" then
		return nil, "error: expect got table"
	end

	local b, e = 1, #_table
	while(b < e) do
		_table[b], _table[e] = _table[e], _table[b]
		b = b + 1
		e = e - 1
	end

	return _table
end

local function print_string(output)
	local gap = 1
	local str_arr = {}
	local to, from = output:get_range()
	local head = string.format("%d,%d:", to - 1, from - 1)

	local binstr = output:binstr()
	local str = convert.output_convert(binstr, output.base)

	for word in string.gmatch(str, "%w") do
		table.insert(str_arr, word)
		if gap == output.gap then
			table.insert(str_arr, output.sep)
			gap = 1
		else
			gap = gap + 1
		end
	end

	-- insert white-space and replace the first separator
	if str_arr[1] == output.sep then
		str_arr[1] = " "
	else
		table.insert(str_arr, 1, " ")
	end

	local body = table.concat(str_arr)

	print(head .. body)
end

local function print_list(output)
	local gap = 1
	local str_arr = {}
	local from, to = output:get_range()
	local head = string.format("%d,%d:\n", to - 1, from - 1)

	for i = from, to, 1 do
		local templete = string.format("[%d] = %s", i - 1, output:bitat(i))
		table.insert(str_arr, 1, templete)
	end
	
	local body = table.concat(str_arr, "\n")

	print(head .. body)
end

-- public function---------------------
function output:get_range()
	return self.from, self.to
end

function output:bitat(idx)
	return self.data[idx]
end

function output:isfull()
	if self.from ~= 1 then
		return false
	end
	
	if #self.data ~= self.to then
		return false
	end

	return true
end

function output:binstr()
	return convert.table_to_binstr(self.data, self:get_range())
end

-- ======= config function ============
--[[
    the range only be configed one times
--]]
function output:set_range_once(from, to)
	self.from = self.from or from
	self.to   = self.to or to
end

--[[
the output range
--]]
function output:set_range(pattern)
	local from, to = convert.parse_range(pattern)
	self:set_range_once(from, to)
end

--[[
the style of output( separator, gap)
--]]
function output:set_style(sep, gap)
	self.sep = sep or self.sep
	self.gap = gap or self.gap
end

--[[
Did the output with list-style.
--]]
function output:set_list(islist)
	self.islist = islist
end

function output:set_base(obase)
	self.base = obase
end

--[[
@bits_table
	usually from bitmap:get()
--]]
function output:set(bits_table)
	self.data = bits_table
	self:set_range_once(1, #bits_table)
end

function output:print()
	if self.base == 2 and self.islist then
		print_list(self)
	else
		print_string(self)
	end
end

return output
