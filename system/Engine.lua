Engine = {}

--[[
	SETUP FUNCTIONS
]]
function Engine:new(options)
	local o = {}
	setmetatable(o, self)
	self.__index = self

	o:registerViewPort(Viewport:new())
	o.entities = Util.List:new()
	return o
end

function Engine:registerViewPort(viewport)

	self.viewport = viewport
end

function Engine:addMap(map)
	self.map = map
end

function Engine:removeMap(map)
	self.map = map
end

function Engine:addEntity(entity)
	return self.entities:add(entity)
end

function Engine:removeEntity(id)
	self.entities:remove(id)
end

function Engine:update(dt, keys)

	for id, e in pairs(self.entities) do
		e:update(dt, keys)
	end

	self.viewport:update(dt, keys)

	self.collisions()
end

function Engine:collisions()
	local tree = Quadtree:new(self.viewport.box, 0)

	
end

function Engine:draw()
	local viewport = self.viewport

	viewport:set()

	if self.map then self.map:draw(viewport) end

	-- find onscreen entities
	local onScreen = {}
	for id, e in pairs(self.entities) do
		if viewport:onScreen(e.box) then
			table.insert(onScreen, e)
		end
	end

	-- draw onscreen entities
	for id, e in pairs(onScreen) do
		e:draw(viewport)
	end

	viewport:unset()
end

