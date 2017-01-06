--[[
@

--]]
-- =============================================================================
-- import
-- =============================================================================
local LUA_GETOPT_PATH = "../lib/lua-getopt/src/?.lua;"
package.path = LUA_GETOPT_PATH .. package.path

-- =============================================================================
-- const
-- =============================================================================
local BIN = "b" -- tag binary
local DEC = "d" -- tag decimal
local HEX = "h" -- tag hexdecimal

-- =============================================================================
-- flages & inner variable
-- =============================================================================
-- type flags
local input_type  = HEX
local output_type = BIN

-- style flags
local width  = 32
local islist = false -- if display with sheet

local gap = 4
local separator = " "

-- inner variable
local rang = nil  -- rang pattern
local bitmap = {} -- inner bitmap
local setmap = {} -- the setting-pattern map

-- convert function
local input
local output
-- =============================================================================
-- function
-- =============================================================================

-- options ---------
-- help infomation
local function usage()
	local info = [[
	bits number [input-type] [options]

	options
	-r range_pattern
	   from:to
	   from+len
	   from

	-i | --input-type {b|d|h}

	-o | --output-type {b|d|h}

	-s | --set-bits {bits,from  [bits,from] [...]}

	-l <y|n>
	   when setting option "-r", this value will set y(--list) at the same time
	   make sense only in --output-type is b
	--list     same as -l y
	--no-list  same as -l n

	-w | --width {number}
	   the min-bits in input, defualt is -w 32
	   make sense only in --output is not list

	-d | --separator | --delimiter {len [separator]}
	   default is '-d 4 " " '
	   make sense only in --output is not list
	]]

	print(info)
end

-- conver function --------------------
-- input hexdecimal to binary
local function i_h2b()

end

-- input decimal to binary
local function i_d2b()

end

-- input binary to binary
local function i_b2b()

end

-- output binary to binary
local function o_b2b()

end

-- output binary to decimal
local function o_b2d()

end

-- output binary to hexdecimal
local function o_b2h()

end


-- main function --------------------
local function main(number, format)

end

-- register opts
