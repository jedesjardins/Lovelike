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

	self:collisionDetection()
end

local function mix(getPos, getBox)
		local x, y = getPos()
		local xoff, yoff, w, h = getBox()

		return x+xoff, y+yoff, w, h
end

local function getHitBox(e)
	local getBox = e.components["collision"]:getClosure({"x", "y", "w", "h"})
	local getPos = e.components["position"]:getClosure({"x", "y"})
	return mix(getPos, getBox)
end

function World:collisionDetection()

	local x = self.cam.components["position"]["x"]
	local y = self.cam.components["position"]["y"]
	local w, h = love.graphics.getDimensions()

	local tree = Quadtree:new(x, y, w, h, 0)
	local list = {}

	for _, e in pairs(self.entities) do
		if e.components["position"] and e.components["collision"] then
			tree:insert(e, getHitBox(e))
			table.insert(list, e)
		end
	end

	for _, e in pairs(list) do
		local others = tree:retreive(getHitBox(e))

		for _, f in pairs(others) do
			if self:detectCollision(e, f) then
				e:get("collision"):resolve(e, f)
				f:get("collision"):resolve(f, e)
			end
		end
	end

	for _, e in pairs(self.entities) do
		e.commandQ:flush()
	end
end

function World:detectCollision(e1, e2)
	if e1 == e2 then return end
	local posx1, posy1 = e1.components["collision"].getPosition()
	local x1, y1, w1, h1 = e1.components["collision"]:getBox()
	x1 = posx1 + x1
	y1 = posy1 + y1

	if not(e2.components["position"] and e2.components["collision"]) then return end

	local posx2, posy2 = e2.components["collision"].getPosition()
	local x2, y2, w2, h2 = e2.components["collision"]:getBox()
	x2 = posx2 + x2
	y2 = posy2 + y2

	return 	self:isPointInside(x1, y1, w1, h1, x2, y2) or
			self:isPointInside(x1, y1, w1, h1, x2 + w2, y2) or
			self:isPointInside(x1, y1, w1, h1, x2, y2 + h2)	or
			self:isPointInside(x1, y1, w1, h1, x2 + w2, y2 + h2)

	
end

function World:isPointInside(x, y, w, h, x2, y2) 
	inX = (x <= x2 and x2 <= x + w)
	inY = (y <= y2 and y2 <= y + h)
	return (inX and inY)
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
		local layerComp = e.components["layer"] or {1}
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