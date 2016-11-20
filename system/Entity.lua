Entity = {}

require("Component")

function Entity:new(comps, parent, children)
	local o = {}
	setmetatable(o, self)
	self.__index = self

	o.components = {}
	o.parent = parent
	o.children = {}
	o.commands = Util.Stack:new()
end

--[[
	SETUP FUNCTIONS
]]
function Entity:addComponents(comps)
	local components = self.components

	for name, comp in pairs(comps or {}) do
		local class = comp[1]
		local component = class:new(comp[2])

		components[name] = component
	end

end

function Entity:removeComponents(comps)
	local components = self.components

	for _, name in pairs(comps) do
		components[name] = nil
	end
end

function Entity:get(name)

	return self.components[name]
end

function Entity:dependencies()

end

function Entity:addParent(entity)

	self.parent = entity
end

function Entity:removeParent(entity)

	self.parent = nil
end

function Entity:addChildren()
	for _, child in pairs(kids or {}) do
		table.insert(self.children, child)
		child.parent = self
	end
end

--[[
	STATE FUNCTIONS
]]
function Entity:update()
	for _, component in pairs(self.components) do
		if(component.update) then
			component:update(dt, keys, self)
		end
	end
end

function Entity:draw()
	for _, component in pairs(self.components) do
		if(component.draw) then
			component:draw()
		end
	end
end

function Entity:send()
	for _, component in pairs(self.components) do
		component:receive(message, self)
	end
end

-- Move this to the components somehow.
function Entity:resolveCollision()
end