Map = {}

function Map:new(options)
	local o = {}
	setmetatable(o, self)
	self.__index = self

	self.image = love.graphics.newImage("resources/Tileset.png")
	self.image:setFilter("nearest", "nearest")

	self.canvas = nil

	self.tiles = {}
	for y=	0, 10 do 
		self.tiles[y] = {}
		for x= 0, 15 do
			self.tiles[y][x] = (x + y)%2
		end
	end

	return o
end

function Map:update(dt, keys)

end

function Map:draw(viewport)
	if not self.canvas then
		self.canvas = love.graphics.newCanvas(400, 300)
		self.canvas:setFilter("nearest", "nearest")
		viewport:setCanvas(self.canvas)
		love.graphics.clear(255, 255, 255)

		for y= 0, 10 do
			for x=0, 15 do 
				local tile = self.tiles[y][x]
				local point = Point:new(x*24, y*24)
				local quad = Box:new(tile*24, 216, 24, 24)
				viewport:draw(self.image, point, quad)
			end
		end
		viewport:setCanvas()
	end
	viewport:draw(self.canvas, Point:new(0, 0))
end

function Map:getTiles()
	
	local tiles = {}
end

