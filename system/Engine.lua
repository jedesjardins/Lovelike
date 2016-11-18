Engine = {}

function Engine:new(options)
	local o = {}
	setmetatable(o, self)
	self.__index = self

	self.image = love.graphics.newImage("resources/Detective.png")
	self.image:setFilter("nearest", "nearest")
	self.posx, self.posy = 0, 0
	self.x, self.y = 0, 0
	self.w = 24
	self.h = 32
	return o
end

function Engine:registerViewPort(viewport)

	self.viewport = viewport
end

function Engine:registerMap(map)

	self.map = map
end

function Engine:update(dt, keys)

	if keys:held("w") then self.posy = self.posy + 4 end
	if keys:held("s") then self.posy = self.posy - 4 end
	if keys:held("d") then self.posx = self.posx + 4 end
	if keys:held("a") then self.posx = self.posx - 4 end


	self.viewport:update(dt, keys)
	self.map:update(dt, keys)
end

function Engine:draw()
	self.viewport:set()
	self.map:draw(self.viewport)
	self.viewport:drawQ(self.image, self.posx, self.posy, self.x, self.y, self.w, self.h)
	self.viewport:unset()
end