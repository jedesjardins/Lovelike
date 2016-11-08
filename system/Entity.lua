Entity = {}

function Entity:new(comps)
	--local components = deepCopy(comps)
	printChildren("comps", comps)

	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.components = {}
	o.updateCs = {}
	o.drawCs = {}
	o:addComponents(comps)
	o:registerDepends()
	return o
end

--[[
	tracks components passed to the entity
	input:	comps:	list of components
]]
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

--[[
	iterates components and registers all functions that a component needs
]]
function Entity:registerDepends()
	for name, component in pairs(self.components) do
		component:registerDepends(self)
	end
end

--[[
	iterates and updates componenents with update functions
	input:	dt:		time elapsed since last frame
			keys:	all keys pressed
]]
function Entity:update(dt, keys)
	for _, component in pairs(self.updateCs) do
		component:update(dt, keys, self)
	end
end

--[[
	iterates and draws componenents with draw functions
]]
function Entity:draw()
	for _, component in pairs(self.drawCs) do
		component:draw()
	end
end

--[[
	sends message to all components
	input:	message:	message to send to components
]]
function Entity:send(message)
	local components = self.components
	for _, comp in pairs(components or {}) do
		comp:receive(message, self)
	end
end
