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
	
	self.viewport:update(dt, keys)
end

function Engine:draw()
	self.viewport:set()
	self.viewport:draw(self.image, 20, 20, self.x, self.y, self.w, self.h)
	self.viewport:unset()
end