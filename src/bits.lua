--[[
@

--]]
-- =============================================================================
-- import
-- =============================================================================
local convert = require("convert")

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

	-d | --delimiter {gap separator}
	   default is '-d 4 " " '
	   make sense only in --output is not list

	--gap {len}
	   default is '--gap 4'
	--sep {separator}
	   default is '--sep " "'
	]]

	print(info)
	os.exit(0)
end
getopt.callback("h,help", usage)

-- input config -----------------------
local function input_base(base)
	local _base = convert.parse_base(base)
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

-- bitmap config -----------------------
local function set_mdf(...)
	local list = {...}
	bitmap:set_mdf(list)
end
getopt.callback("s,set-bits:U:1", set_mdf)


-- output config -----------------------
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
		error("error set list output")
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

local function output_base(base)
	local _base = convert.parse_base(base)
	output:set_base(_base)
end
getopt.callback("o,output-base:N:1", output_base)

local function set_gap(len)
	output:set_style(nil, tonumber(len))
end
getopt.callback("gap:N:1", set_gap)

local function set_sep(separator)
	output:set_style(separator, nil)
end
getopt.callback("sep:N:1", set_sep)

local function set_delimiter(gap, sep)
	set_sep(sep)
	set_gap(gap)
end
getopt.callback("d,delimiter:N:2", set_delimiter)

-- main function --------------------
local function main(number, ibase, obase)
	if not number then 
		error("none number input, you call use -h for help")
	end
	input:set_number(number)
	local _ = ibase and input_base(ibase)
	local _ = obase and output_base(obase)


	local i_bits = input:convert()
	bitmap:set(i_bits)
	bitmap:modify()
		
	local o_bits = bitmap:get()
	output:set(o_bits)
	output:print()
end
getopt.setmain(main)

-- =============================================================================
-- main entry
-- =============================================================================
local function run(param)
	getopt.run(param)
end

return { run = run }
