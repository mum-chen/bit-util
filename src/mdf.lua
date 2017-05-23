-- =============================================================================
-- import
-- =============================================================================
local convert = require("convert")

local _check   = convert.base_check
local _totable = convert.binstr_to_table

-- =============================================================================
-- modify item
-- =============================================================================
local mdf_item = {
	bits = nil,
	from = nil,
	to   = nil,
}

function mdf_item:_new(bits, from, to)
	local item = {
		bits = bits,
		from = from,
		to   = to,
	}
	
	setmetatable(item, {__index = self})

	return item
end


function mdf_item.convert(bits)
	local ret = _check(bits, 2)
	if not ret then
		local err = "error set-bits: got %s, expect got {1|0}"
		error(string.format(err, bits))
	end

	local t = _totable(bits, 0)
	return t
end

function mdf_item:new(pattern)

	local bits, from = pattern:match("^(%d+),(%d+)$")
	if not (bits and from) then
		local err = "error set-bits pattern:%s, expect got {bits,from}"
		error(string.format(err, pattern))
	end
	
	bits_table = self.convert(bits)
	
	from = tonumber(from) + 1

	local to = from + #bits - 1

	return self:_new(bits_table, from, to)
end

--[[
only modify the index that exists in both bit_map and self.bits
--]]
function mdf_item:modify(bit_map)
	local idx = 1
	for i = self.from, self.to, 1 do
		if not bit_map[i] then
			break
		end
		bit_map[i] = self.bits[idx]
		idx = idx + 1
	end

	return bit_map
end

-- =============================================================================
-- modify list
-- =============================================================================
local mdf = {}

--[[
@list	modification list
--]]
function mdf:set_mdf(list)
	for _, pattern in ipairs(list) do
		local item = mdf_item:new(pattern)
		table.insert(self, item)
	end
end

function mdf:modify(bits)
	for i, item in ipairs(self) do
		item:modify(bits)
	end
end

return mdf
