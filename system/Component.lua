Component = Object:new{
	dependencies = {}
}

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
			if attributes[k] and type(v) == type(self[attributes[k]]) then
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