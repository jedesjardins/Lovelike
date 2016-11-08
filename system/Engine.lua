Engine = {}

function Engine:new(o)
	local o = o or {}
	setmetatable(o, self)
	self.__index = self
	o.entities = Util.List:new()
	return o
end

--[[
	updates all entities in engine
]]
function Engine:update(dt, keys)
	for _, e in pairs(self.entities) do
		e:update(dt, keys)
	end
end

--[[
	draws all entities in engine
]]
function Engine:draw()
	for _, e in pairs(self.entities) do
		e:draw()
	end
end

--[[
	adds an entity to the engine
]]
function Engine:registerEntity(entity)

	return self.entities:add(entity)
end

--[[
	removes entities from the engine
]]
function Engine:removeEntity(id)
	
	self.entities:remove(id)
end


require("Entity")
require("Component")

require("components")
require("entities")