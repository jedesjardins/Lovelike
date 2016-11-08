Component = {
	dependencies = {}
}

function Component:new(listOptions)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o:init(listOptions)
	return o
end

--[[
	sets starting attributes of component
	input:	listAttributes: sets initial values of the component 
]]
function Component:init(listAttributes)
	for k, v in pairs(listAttributes or {}) do
		self[k] = v
	end
end

--[[
	overload for components that require this function
	iterates dependencies of this component and 
]]
function Component:registerDepends(e)
end

--[[
	generates generic closure, do not overload
	getter for specific attributes of this component
	input:	attributes:	list of keys to get
	output:	closure:	function that returns values designated by attributes
]]
function Component:getClosure(attributes)
	return function()
		local list = {}
		for k, v in ipairs(attributes) do
			table.insert(list, self[v])
		end
		return unpack(list)
	end 
end

--[[
	generates generic closure, do not overload
	setter for specific attributes of this component
	input:	attributes:	list of keys to set
	output:	closure:	function that takes values and sets designated 
						attributes
]]
function Component:setClosure(attributes)
	return function(list)
		for k, v in ipairs(list) do
			if attributes[k] and type(v) == type(attributes[k]) then
				self[attributes[k]] = v
			end
		end
	end
end

--[[
	overload for components that require this function
	receive processes messages from other components
]]
function Component:receive(message)
end