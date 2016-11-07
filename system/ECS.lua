--[[
	Simple Entity Component System

	Entities are just ids

	Components are wrappers for simple data

	Systems are logic and containers for components
]]

local Engine = {}

function Engine:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self

	-- list of existing entities
	o.entities = Util.List:new()
	-- map of type to component list
	o.components = {}
	-- update systems
	o.updateSystems = {}
	-- draw systems
	o.drawSystems = {}
	--
	o.initSystems = {}
	return o
end

--[[
	Creates a new entity, represented by an id
	params: no arguments
	return: id of entity created
]]
function Engine:newEntity()
	local id = self.entities:add()
	return id
end

--[[
	Creates a new component, just a wrapper for attributes
	params:	o:		component passed in
			id:		entity that this belongs to 
			kind: 	type of the component
	return: component created (unnecessary?)
]]
function Engine:newComponent(o, id, kind)
	-- Make map of id to component for this type 
	if not self.components[kind] then
		self.components[kind] = Util.Map:new()
	end
	local map = self.components[kind]

	o = o or {}
	-- track this component for the passed in type
	map:add(id, o)
	return o
end

function Engine:removeComponent(id, kind)
	-- Make map of id to component for this type 
	if not self.components[kind] then
		self.components[kind] = Util.Map:new()
	end
	local map = self.components[kind]

	-- track this component for the passed in type
	map:remove(id)
end

--[[
	Creates a new system, wrapper for logic
	params:	o:		system passed in
			kind: 	type of the system, either draw or update
	return: system created (unnecessary?)
]]
function Engine:newSystem(o, kind, comps)
	local systemList = 0
	if kind == "update" then
		systemList = self.updateSystems
	elseif kind == "draw" then
		systemList = self.drawSystems
	elseif kind == "init" then
		systemList = self.initSystems
	end
	o = o or {}
	table.insert(systemList, o)

	self:trackComponents(o, comps)
	return o
end

-- TODO: This does not account for priority
function Engine:addSystem(system)
	local sys = self:newSystem(system.logic, system.kind, system.comps)
end

--[[
	add a list of systems to the engine
	systems must have a kind, a comps list, and a logic 
	section with the corresponding method
]]
function Engine:addSystems(systems)
	for k, v in pairs(systems) do 
		-- v is the actual system
		local sys = self:newSystem(v.logic, v.kind, v.comps)
	end

	self:sortSystems()
end

function Engine:sortSystems()
	compare = function(a, b)
		return (a["priority"] or 2) < (b["priority"] or 2)
	end

	table.sort(self.updateSystems, compare)
	table.sort(self.drawSystems, compare)
end

function Engine:addEntities(entities)
	for _, e in pairs(entities) do
		addEntity(e)
	end
end

-- deep copy is used so data of entity is original, but images and shit is reused
function Engine:addEntity(entity)
	local id = self:newEntity()

	for kind, comp in pairs(entity) do
		self:newComponent(deepCopy(comp), id, kind)
	end

	return id
end

--[[
	Adds new components that this system will track
	This function may be unnecessary
	params:	system:	system that is tracking new components
			comps:	list of  component types to track
	return: N/A
]]
function Engine:trackComponents(system, comps)
	for _, kind in pairs(comps) do
		if not self.components[kind] then
			self.components[kind] = Util.Map:new()
		end

		system[kind] = self.components[kind]
	end
end

--[[
	Calls update logic on each system
	params:	dt:		time elapsed
	return: N/A
]]
function Engine:update(dt, keys)
	-- iterate update Systems list and call update on them
	for k, v in pairs(self.initSystems) do
		v:init()
		self.initSystems[k] = nil
	end

	for _, v in pairs(self.updateSystems) do
		v:update(dt, keys)
	end
end

--[[
	Calls draw logic on each system
	params:	N/A
	return: N/A
]]
function Engine:draw()
	for _, v in pairs(self.drawSystems) do
		v:draw()
	end
end

return Engine

