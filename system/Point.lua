
Point = {x = 0, y = 0}

function Point:new(x, y)
	local o = {}
	setmetatable(o, self)
	self.__index = self

	o.x = x or 0
	o.y = y or 0
	return o
end
