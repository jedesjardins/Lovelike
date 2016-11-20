Entity = {}

function Entity:new(comps, parent, children)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.components = {}
	o.parent = parent
	o.children = {}
	o.commandQ = Util.Stack:new()
	o:addComponents(comps)
	o:registerDepends()
	o:addParent(parent)
	o:addChildren(children)
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
	for name, comp in pairs(comps or {}) do

		local class = comp[1]
		local component = class:new(comp[2])

		components[name] = component
		--if component.update then table.insert(updateCs, component) end
		--if component.draw then table.insert(drawCs, component) end
	end
end

function Entity:removeComponents(comps)
	local components = self.components
	local updateCs = self.updateCs
	local drawCs = self.drawCs
	for _, name in pairs(comps) do
		components[name] = nil
		--updateCs[name] = nil
		--components[name] = nil
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

function Entity:addParent(entity)
	self.parent = entity
end

function Entity:addChildren(kids)
	for _, child in pairs(kids or {}) do
		table.insert(self.children, child)
		child.parent = self
	end
end

--[[
	iterates and updates componenents with update functions
	input:	dt:		time elapsed since last frame
			keys:	all keys pressed
]]
function Entity:update(dt, keys)
	for _, component in pairs(self.components) do
		if(component.update) then
			component:update(dt, keys, self)
		end
	end
end

function Entity:resolveCollision()
	while not self.commandQ:isEmpty() do
		local c = self.commandQ:pop()
		c.Undo()
	end
end

--[[
	iterates and draws componenents with draw functions
]]
function Entity:draw()
	for _, component in pairs(self.components) do
		if(component.draw) then
			component:draw()
		end
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

function Entity:get(component)
	return self.components[component]
end

--[[
	COMMANDS
]]

function Entity:makeMoveCommand(direction)

	if not self:get("position") then return end

	local getPosition = self:get("position"):getClosure({"x", "y"})
	local setPosition = self:get("position"):setClosure({"x", "y"})

	local xoff, yoff = 0, 0
	if direction == "up" then yoff = -2 end
	if direction == "down" then yoff = 2 end
	if direction == "left" then xoff = -2 end
	if direction == "right" then xoff = 2 end
	
	local x, y = getPosition()
	local command = {
		Do = function()
			setPosition{x+xoff, y+yoff}
			self:send{"move", direction}
		end,
		Undo = function()
			setPosition{x, y}
			self:send{"move", "stand"}
		end
	}

	self.commandQ:push(command)
	return command
end