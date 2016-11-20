
Box = {x = 0, y = 0, w = 0, h = 0}

function Box:new(x, y, w, h)
	local o = {}
	setmetatable(o, self)
	self.__index = self

	o.x = x or 0
	o.y = y or 0
	o.w = w or 0
	o.h = h or 0
	return o
end

function Box:getPoints()
	return {
		Point:new(self.x, self.y),
		Point:new(self.x + self.w, self.y),
		Point:new(self.x, self.y + self.h),
		Point:new(self.x + self.w, self.y + self.h)
	}
end

function Box:inside(point)
	local inX = (self.x <= point.x and point.x <= self.x + self.w)
	local inY = (self.y <= point.y and point.y <= self.y + self.h)
	return (inX and inY)
end

function Box:overlap(box)
	local points = box:getPoints()
	local anyInside = false

	for _, point in pairs(points) do
		if self:inside(point) then return true end
	end
	return false
end

