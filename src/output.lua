-- import ------------------------------
local constant = require("constant")
-- output ------------------------------
local output = {
	-- inner bitmap
	data = nil,
	
	-- outputbase
	base = 2,
	
	-- range
	from = 1,
	to   = 32,

	-- style flags
	gap = 4,
	sep = " ",
	islist = false,  -- if display with sheet
}
function output:set_range(from, to)
	self.from = from
	self.to   = to
end

function output:set_style(sep, gap)
	self.sep = sep
	self.gap = gap
end

function output:set_list(islist)
	self.islist = islist
end

function output:set()

end

function output:get()

end

return output
