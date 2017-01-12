--[[
@

--]]
-- =============================================================================
-- import
-- =============================================================================
-- load constant
local constant = require("constant")

-- load 3rd module
local getopt = require("getopt")

-- load module
local input   = require("input")
local output = require("output")
local bitmap = require("bitmap")

-- =============================================================================
-- options setting
-- =============================================================================
-- help infomation
local function usage()
	local info = [[
	bits number [input-base] [options]

	options
	-h | --help
	   help info

	-r range_pattern
	   from:to
	   from+len
	   from      same as from:from
	   from:     same as from:end
	   from+     same as from

	-i | --input-base {b|d|h}

	-o | --output-base {b|d|h}

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
	os.exit(0)
end
getopt.callback("h,help", usage)

local function input_base(base)
	local _base
	base = string.lower(base)
	if constant.HEX == base then
		_base = 16
	elseif constant.DEC == base then
		_base = 10
	elseif constant.BIN == base then
		_base = 2
	else
		local info = string.format(
		"error base input, expect get(b|d|h), got %s.\n",
		tostring(base)
		)
		error(info)
	end

	input:set_base(_base)
end
getopt.callback("i,input-base:N:1", input_base)

local function set_width(width)
	local _w = tonumber(width)
	if not _w then
		error("width except get number")
	end

	input:set_width(_w)
end
getopt.callback("w,width:N:1", set_width)


local function set_mdf(...)
	local list = {...}
	bitmap:set_mdf(list)
end
getopt.callback("s,set-bits:U:1", set_mdf)

local function set_range(pattern)
	output:set_range(pattern)
end
getopt.callback("r,range:N:1", set_range)

local function set_list(list)
	if (list == "y") or  (lsit == "Y") then
		output:set_list(true)
	elseif (list == "n") or (list == "N") then
		output:set_list(false)
	else
		error("error set list input")
	end
end
getopt.callback("l:N:1", set_list)

local function nolist()
	output:set_list(false)
end
getopt.callback("no-list", nolist)

local function list()
	output:set_list(true)
end
getopt.callback("list", list)


-- main function --------------------
local function main(number, base)
	if not number then 
		error("none number input")
	end
	input:set_number(number)
	local _ = base and input_base(base)

	local i_bits = input:convert()
	bitmap:set(i_bits)
	bitmap:modify()
		
	local o_bits = bitmap:get()
	output:set(o_bits)
	output:get()
end
getopt.setmain(main)


-- =============================================================================
-- main entry
-- =============================================================================
local function run(param)
	getopt.run(param)
end

return { run = run }
