Viewport = {}

-- TODO: guarantee option inputs are numbers
function Viewport:new(options)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	options = options or {}
	self.box = Box:new(options[1] or 0,
						options[2] or 0,
						options[3] or 400,
						options[4] or 300)

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

function Viewport:setCanvas(canvas)
	-- mark that we are drawing to canvas
	if canvas then
		self.canvas = canvas
	else
		self.canvas = nil
	end
	love.graphics.setCanvas(canvas)
end

function Viewport:isTargetCanvas()

	return self.canvas
end

function Viewport:drawRect(x, y, w, h)
	local ax, ay, aw, ah = self:translateRect(x, y, w, h)
	love.graphics.rectangle("fill", ax, ay, aw, ah)
end

function Viewport:draw(image, point, box, r)
	if box then
		local quad, scale = self:translateQuad(box.x, box.y, box.w, box.h, image:getDimensions())
		local px, py = self:translateRect(point.x, point.y, box.w, box.h)
		if self.canvas then scale = 1 end
		love.graphics.draw(image, quad, px, py, r or 0, scale, scale)
	else
		local imgW, imgH = image:getDimensions()
		local px, py = self:translateRect(point.x, point.y, imgW, imgH)
		local scale = self:getScale()
		love.graphics.draw(image, px, py, r or 0, scale, scale)
	end
end

--[[
	STATE ACTIONS
]]

function Viewport:update(dt, keys)
	if keys:held("return") then self:zoomIn() end
	if keys:held("rshift") then self:zoomOut() end
	if keys:pressed("lshift") then self:centerOnPoint(0, 0) end
	if keys:held("up") then self:setPosition(self.box.x, self.box.y + 2) end
	if keys:held("down") then self:setPosition(self.box.x, self.box.y - 2) end
	if keys:held("right") then self:setPosition(self.box.x + 2, self.box.y) end
	if keys:held("left") then self:setPosition(self.box.x - 2, self.box.y) end
end

function Viewport:setPosition(x, y)
	self.box.x = x
	self.box.y = y
end

function Viewport:setSize(w, h)
	self.box.w = w
	self.box.h = h
end

function Viewport:centerOnPoint(x, y)

	self:setPosition(x - self.box.w/2, y - self.box.h/2)
end

function Viewport:centerOnBox(x, y, w, h)

	self:setPosition(x - self.box.w/2+ w/2, y - self.box.h/2+ h/2)
end

function Viewport:zoomIn(x, y)
	if self.box.w < 100 then return end

	local cx = self.box.x + self.box.w/2 
	local cy = self.box.y + self.box.h/2

	-- TODO: how much should x and y be shifted?
	local dw = self.box.w * .1
	self.box.x = self.box.x + dw/2
	self.box.w = self.box.w - dw/2

	local dh = self.box.h * .1
	self.box.y = self.box.y + dh/2
	self.box.h = self.box.h - dh/2

	if x and y then
		self:centerOnPoint(x, y)
	else
		self:centerOnPoint(cx, cy)
	end
end

function Viewport:zoomOut(x, y)
	if self.box.w > 1600 then return end

	local cx = self.box.x + self.box.w/2 
	local cy = self.box.y + self.box.h/2

	-- TODO: how much should x and y be shifted?

	local dw = self.box.w * .1
	self.box.x = self.box.x - dw/2
	self.box.w = self.box.w + dw/2

	local dh = self.box.h * .1
	self.box.y = self.box.y - dh/2
	self.box.h = self.box.h + dh/2

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
	if not (w and h) then
		w, h = 0, 0
	end

	if self.canvas then
		local canvasHeight = self.canvas:getHeight()
		local ay = canvasHeight - y - h

		return x, ay, w, h
	else
		local scale = self:getScale()

		local aw = scale*w
		local ah = scale*h

		local ax = scale * (x - self.box.x)
		local ay = self.screenH - (scale * (y - self.box.y)) - ah

		return ax, ay, aw, ah
	end
end

-- TODO: prioritize quads so that only a given number are memoized
function Viewport:translateQuad(x, y, w, h, iw, ih)
	local scale = self:getScale()

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

function Viewport:getScale()

	return self.screenH / self.box.h
end

function Viewport:onScreen(box)
	--local screen = Box:new(self.x, self.y, self.w, self.h)
	return self.box:overlap(box)
end
