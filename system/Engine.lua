Engine = {}

function Engine:new(o)
	local o = o or {}
	setmetatable(o, self)
	self.__index = self
	o.entities = Util.List:new()
	return o
end

function Engine:update(dt, keys)
	for _, e in pairs(self.entities) do
		e:update(dt, keys)
	end
end

function Engine:draw()
	for _, e in pairs(self.entities) do
		e:draw()
	end
end

function Engine:registerEntity(entity)
	return self.entities:add(entity)
end

-- TODO: how does an entity know how to delete itself from the engine?
function Engine:removeEntity(id)
	self.entities:remove(id)
end

Entity = {}

function Entity:new(comps)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.components = {}
	o.updateCs = {}
	o.drawCs = {}
	o:addComponents(comps)
	return o
end

function Entity:update(dt, keys)
	for _, component in pairs(self.updateCs) do
		component:update(dt, keys, self)
	end
end

function Entity:draw()
	for _, component in pairs(self.drawCs) do
		component:draw()
	end
end

function Entity:send(message)
	local components = self.components
	for _, comp in pairs(components or {}) do
		comp:receive(message)
	end
end

function Entity:addComponents(comps)
	local components = self.components
	local updateCs = self.updateCs
	local drawCs = self.drawCs
	for name, component in pairs(comps or {}) do
		components[name] = component
		if component.update then table.insert(updateCs, component) end
		if component.draw then table.insert(drawCs, component) end
	end
end

Component = {}

function Component:new()
	local o = {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function Component:receive(message)
	-- handle messages
	print(message)
end

require("components")