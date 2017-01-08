-- =============================================================================
-- import
-- =============================================================================
local constant = require("constant")
local modify   = require("mdf")
-- bitmap ------------------------------
local bitmap = {
	-- inner data
	data = nil,
}

-- =============================================================================
-- public function
-- =============================================================================
-- set & get --------------------------
function bitmap:set(bit_table)
	self.data = bit_table
end

function bitmap:get()
	return self.data
end

--[[
@list	modification list
--]]
function bitmap:set_mdf(list)
	modify:set_mdf(list)
end

-- deal -------------------------------
function bitmap:modify()
	modify:modify(self.data)
end


return bitmap
