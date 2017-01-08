-- =============================================================================
-- import
-- =============================================================================
local constant = require("constant")
local convert  = require("convert")

_convert_base = convert.input_convert
_to_table     = convert.binstr_to_table
-- =============================================================================
-- input
-- =============================================================================
local input = {
	-- number input (string format)
	num = nil,
	-- base flags
	base  = 16,
	-- modification list
	width  = 32,
}

-- public function---------------------
-- set & get
function input:set_width(width)
	self.width = width
end

function input:set_number(num)
	local number = string.upper(num)
	local _temp = number:match("0X(.*)")
	self.num = _temp or number
end

function input:set_base(base)
	self.base = base
end

-- deal
--[[
@desc	check param input & convert string to bits-table
@return	bits-table
--]]
function input:convert()
	local binstr = _convert_base(input.num, input.base)
	local bits = _to_table(binstr, input.width)
	return bits
end

-- =============================================================================
-- retuern
-- =============================================================================
return input
