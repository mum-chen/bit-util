-- =============================================================================
-- import
-- =============================================================================
local convert = require("convert")

local parse_range = convert.parse_range
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
	local from, to = output:get_range()
	local head = string.format("%d,%d:", to - 1, from - 1)


	for i = from, to, 1 do
		table.insert(str_arr, output:bit(i))

		if gap == output.gap then
			table.insert(str_arr, output.sep)
			gap = 1
		else
			gap = gap + 1
		end
	end

	local last = #str_arr
	if str_arr[last] == output.sep then
		str_arr[last] = " "
	else
		str_arr[last + 1] = " "
	end

	reverse(str_arr)

	local body = table.concat(str_arr)

	print(head .. body)
end

local function print_list(output)
	local gap = 1
	local str_arr = {}
	local from, to = output:get_range()
	local head = string.format("%d,%d:\n", to - 1, from - 1)

	for i = from, to, 1 do
		local templete = string.format("[%d] = %s", i - 1, output:bit(i))
		table.insert(str_arr, templete)
	end
	
	reverse(str_arr)

	local body = table.concat(str_arr, "\n")

	print(head .. body)
end

-- public function---------------------
--[[
    the range only be configed one times
--]]
function output:_set_range(from, to)
	self.from = self.from or from
	self.to   = self.to or to
end

function output:get_range()
	return self.from, self.to
end


function output:bit(idx)
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

function output:set_range(pattern)
	local from, to = parse_range(pattern)
	self:_set_range(from, to)
end

function output:set_style(sep, gap)
	self.sep = sep
	self.gap = gap
end

function output:set_list(islist)
	self.islist = islist
end

function output:set(bits_table)
	self.data = bits_table
	self:_set_range(1, #bits_table)
end

function output:get()
	local list = self.islist

	if list then
		print_list(self)
	else
		print_string(self)
	end
end

return output
