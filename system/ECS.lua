--[[
	Simple Entity Component System

	Entities are just ids

	Components are wrappers for simple data

	Systems are logic and containers for components
]]

Engine = {}

function Engine:new(o)
	o = o or {}
	setmetatable(o, self)
	o.Components = {}
	self.__index = self

	-- list of existing entities
	o.entities = Util.List:new()
	-- map of type to component list
	o.components = {}
	-- update systems
	o.updateSystems = {}
	-- draw systems
	o.drawSystems = {}
	return o
end

--[[
	Creates a new entity, represented by an id
	params: no arguments
	return: id of entity created
]]
function Engine:newEntity()
	id = self.entities:add()
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

--[[
	Creates a new system, wrapper for logic
	params:	o:		system passed in
			kind: 	type of the system, either draw or update
	return: system created (unnecessary?)
]]
function Engine:newSystem(o, kind)
	local systemList = 0
	if kind == "update" then
		systemList = self.updateSystems
	elseif kind == "draw" then
		systemList = self.drawSystems
	end
	o = o or {}
	table.insert(systemList, o)
	return o
end

--[[
	add a list of systems to the engine
	systems must have a kind, a comps list, and a logic 
	section with the corresponding method
]]
function Engine:addSystems(systems)
	for k, v in pairs(systems) do 
		-- v is the actual system
		local sys = self:newSystem(v.logic, v.kind)
		-- log the components it tracks
		self:trackComponents(sys, v.comps)
	end
end

--[[
	Adds new components that this system will track
	This function may be unnecessary
	params:	system:	system that is tracking new components
			comps:	list of  component types to track
	return: N/A
]]
function Engine:trackComponents(system, comps)
	--[[
	if type(comps) == "string" then
		comps = {comps}
	end
	]]

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

