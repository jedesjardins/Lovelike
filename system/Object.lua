
Object = {}
local mt = {}

print(Object)
function Object:new(options)
	o = {}
	options = options or {}
	
	setmetatable(o, {__index = function(table, key)
		if self == Object and not(key == "new" or key == "init") then
			return nil
		end
		local ret = self[key]
		if ret == nil then return nil end

		table[key] = ret
		return table[key]
	end})

	o:init(options)
	return o
end

function Object:init(options)
	for k, v in pairs(options) do
		self[k] = v
	end
end

