Engine = {}

function Engine:new(options)
	local o = {}
	setmetatable(o, self)
	self.__index = self

	self.image = love.graphics.newImage("resources/Detective.png")
	self.image:setFilter("nearest", "nearest")
	self.x, self.y = 0, 0
	self.w = 24
	self.h = 32

	return o
end

-- viewport should translate all drawing and 
-- shiz to actual pixels.
function Engine:registerViewPort(viewport)
	self.viewport = viewport
end

function Engine:update(dt, keys)
	if keys:held("return") then self.viewport:zoomIn(0, 0) end
	if keys:held("rshift") then self.viewport:zoomOut(0, 0) end
	if keys:pressed("lshift") then self.viewport:centerOnBox(20, 20, 24, 32) end
end

function Engine:draw()
	self.viewport:set()
	self.viewport:draw(self.image, 20, 20, self.x, self.y, self.w, self.h)
	self.viewport:unset()
end