Engine = {}

function Engine:new(options)
	local o = {}
	setmetatable(o, self)
	self.__index = self

	self.entities = {}

	self.image = love.graphics.newImage("resources/Detective.png")
	self.image:setFilter("nearest", "nearest")
	self.point = Point:new(0, 0)
	self.box = Box:new(0, 0, 24, 32)
	return o
end

function Engine:registerViewPort(viewport)

	self.viewport = viewport
end

function Engine:registerMap(map)

	self.map = map
end

function Engine:update(dt, keys)

	if keys:held("w") then self.point.y = self.point.y + 4 end
	if keys:held("s") then self.point.y = self.point.y - 4 end
	if keys:held("d") then self.point.x = self.point.x + 4 end
	if keys:held("a") then self.point.x = self.point.x - 4 end


	self.viewport:update(dt, keys)
	self.map:update(dt, keys)
end

function Engine:draw()
	self.viewport:set()
	--self.map:draw(self.viewport)
	self.viewport:draw(self.image, self.point, self.box)
	self.viewport:unset()
end 