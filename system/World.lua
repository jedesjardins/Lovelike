World = {}

function World:new(o)
	local o = o or {}
	setmetatable(o, self)
	self.__index = self
	o.entities = Util.List:new()
	return o
end

--[[
	updates all entities in engine
]]
function World:update(dt, keys)
	if(self.map) then self.map:update(dt, keys) end
	for _, e in pairs(self.entities) do
		e:update(dt, keys)
	end
end

--[[
	draws all entities in engine
]]
function World:draw()
	if self.cam then
		love.graphics.push()
		local x = self.cam.components["position"]["x"]
		local y = self.cam.components["position"]["y"]
		love.graphics.translate(-x, -y)
	end

	layersToId = {}

	for id, e in pairs(self.entities) do
		local layerComp = e.components["layer"]
		if layerComp then
			local layer = layerComp[1] or 1
			layersToId[layer] = layersToId[layer] or {}
			table.insert(layersToId[layer], id)
		end
	end

	for layer, ids in pairs(layersToId) do
		for _, id in pairs(ids) do
			local e = self.entities[id]
			e:draw()
		end
	end

	-- e:draw()

	if self.cam then
		love.graphics.pop()
	end
end

--[[
	adds an entity to the engine
]]
function World:registerEntity(entity)

	return self.entities:add(entity)
end

function World:registerMap(map)
	self.map = map
end

function World:registerCamera(cam)
	self.cam = cam
	self.entities:add(cam)
end

--[[
	removes entities from the engine
]]
function World:removeEntity(id)
	
	self.entities:remove(id)
end


require("Entity")
require("Component")

require("components")
require("entities")