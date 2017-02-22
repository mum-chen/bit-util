-- require below Lua 5.3
-- =============================================================================
-- Math extend
-- =============================================================================
math.tointeger = math.tointeger or function(num)
	local num = tonumber(num)
	if not num then
		return nil
	end

	return math.floor(num)
end

math.type = math.type or function(num)
	local res1 = tonumber(num)
	local res2 = math.tointeger(num)

	if not (res1 and res2) then
		return nil
	end

	return (res1 == res2) and "integer" or "float"
end

-- =============================================================================
-- pairs extend
-- =============================================================================
if _VERSION == "Lua 5.1" then
local ori_pairs = pairs

function pairs(t)
	local mt = getmetatable(t)

	_pairs = (mt and mt["__pairs"]) or ori_pairs
	return _pairs(t)
end

end
