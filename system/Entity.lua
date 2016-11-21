Entity = Object:new()

require("Component")

function Entity:init(options)
	options = options or {}
	local comps = options[1] or {}
	local parent = options[2]
	local children = options[3]

	self.components = {}
	self:addComponents(comps)
	self:addParent(parent)
	self:addChildren(children)
end

--[[
	SETUP FUNCTIONS
]]
function Entity:addComponents(comps)
	local components = self.components

	for name, comp in pairs(comps or {}) do
		components[name] = component:new()
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