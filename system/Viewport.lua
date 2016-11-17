--[[
	Do all the drawing here 
	
	attributes:
		position: position of the world
		size: dimensions of world seen, used also for scale
		layers: canvases to be drawn to
		quads: memoize quads

	functions:
		override basic love.graphics functions

]]

Viewport = {}

-- TODO: guarantee option inputs are numbers
function Viewport:new(options)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	options = options or {}
	self.x = options[1] or 0
	self.y = options[2] or 0
	self.w = options[3] or 400
	self.h = options[4] or 300

	self.screenW, self.screenH = love.graphics.getDimensions()

	self.quads = {}

	--[[
		self.quads in the form of self.quads[iW..iH][x..y..w..h]
	]]

	return o
end

--[[
	DRAW ACTIONS
]]

function Viewport:set()
	--screenW, screenH = love.graphics.getDimensions()
	--love.graphics.scale(screenW/self.w, screenH/self.h)
end

function Viewport:unset()
	--
	--
end

function Viewport:drawRect(x, y, w, h)
	local ax, ay, aw, ah = self:translateRect(x, y, w, h)
	love.graphics.rectangle("fill", ax, ay, aw, ah)
end

function Viewport:draw(image, posx, posy, x, y, w, h, r)


	local quad, scale = self:translateQuad(x, y, w, h, image:getDimensions())
	local px, py = self:translateRect(posx, posy, w, h)
	love.graphics.draw(image, quad, px, py, r or 0, scale, scale)
end

--[[
	STATE ACTIONS
]]

function Viewport:update(dt, keys)
	if keys:held("return") then self:zoomIn(0, 0) end
	if keys:held("rshift") then self:zoomOut(0, 0) end
	if keys:pressed("lshift") then self:centerOnBox(20, 20, 24, 32) end
	if keys:held("up") then self:setPosition(self.x, self.y - 2) end
	if keys:held("down") then self:setPosition(self.x, self.y + 2) end
	if keys:held("right") then self:setPosition(self.x - 2, self.y) end
	if keys:held("left") then self:setPosition(self.x + 2, self.y) end
end

function Viewport:setPosition(x, y)
	self.x = x
	self.y = y
end

function Viewport:setSize(w, h)
	self.w = w
	self.h = h
end

function Viewport:centerOnPoint(x, y)
	
	self:setPosition(x - self.w/2, y - self.h/2)
end

function Viewport:centerOnBox(x, y, w, h)

	self:setPosition(x - self.w/2+ w/2, y - self.h/2+ h/2)
end

function Viewport:zoomIn(x, y)
	if self.w < 100 then return end

	local cx = self.x + self.w/2 
	local cy = self.y + self.h/2

	-- TODO: how much should x and y be shifted?
	local dw = self.w * .1
	self.x = self.x + dw/2
	self.w = self.w - dw/2

	local dh = self.h * .1
	self.y = self.y + dh/2
	self.h = self.h - dh/2

	if x and y then
		self:centerOnPoint(x, y)
	else
		self:centerOnPoint(cx, cy)
	end
end

function Viewport:zoomOut(x, y)
	if self.w > 1600 then return end

	local cx = self.x + self.w/2 
	local cy = self.y + self.h/2

	-- TODO: how much should x and y be shifted?

	local dw = self.w * .1
	self.x = self.x - dw/2
	self.w = self.w + dw/2

	local dh = self.h * .1
	self.y = self.y - dh/2
	self.h = self.h + dh/2

	if x and y then
		self:centerOnPoint(x, y)
	else
		self:centerOnPoint(cx, cy)
	end
end

--[[
	HELPERS
]]

function Viewport:translateRect(x, y, w, h)

	local scale = self.screenH / self.h

	if not (w and h) then
		w, h = 0, 0
	end

	local aw = scale*w
	local ah = scale*h

	local ax = scale * (x - self.x)
	local ay = self.screenH - (scale * (y - self.y)) - ah

	return ax, ay, aw, ah
end

function Viewport:translateQuad(x, y, w, h, iw, ih)
	local scale = self.screenH / self.h

	local ax, aw, ah = x, w, h
	local ay = ih - y - h

	local key = iw..ih
	if self.quads[key] and self.quads[key][x..y..w..h] then
		-- load memoized copy
		local quad = self.quads[key][x..y..w..h]
		return quad, scale
	else
		-- create memoized copy
		local quad = love.graphics.newQuad(ax, ay, aw, ah, iw, ih)
		self.quads[key] = self.quads[key] or {}
		self.quads[key][x..y..w..h] = quad
		return quad, scale
	end
end

