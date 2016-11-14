Util = {}

--[[
	Basic List, can add element or boolean, or remove by index.

	- elements are not contiguous in index
	- new elements are placed in the lowest open index (holes)
	- removing an element will leave it blank

]]
local List = {}

function List:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function List:add(o)
	local i = #self + 1
	self[i] = o or true
	return i
end

function List:remove(i)
	if not i then
		print("Parameter Error")
		return
	end

	self[i] = nil
end

local Queue = {}

function Queue:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	o.front = 0
	o.back = 0
	return o
end

function Queue:push(el)
	self[self.back] = el
	self.back = self.back + 1
end

function Queue:pop()
	if self:isEmpty() then error("Queue is empty") end

	local value = self[self.front]
	self[self.front] = nil        -- to allow garbage collection
	self.front = self.front + 1
	return value
end

function Queue:isEmpty()
	return self.front == self.back
end

function Queue:flush()
	while not self:isEmpty() do
		print(self.front, self.back)
		self:pop()
	end
end

local Stack = {}

function Stack:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	o.top = 0
	return o
end

function Stack:push(el)

	self[self.top] = el
	self.top = self.top + 1
end

function Stack:pop()
	if self:isEmpty() then error("Queue is empty") end

	self.top = self.top - 1
	local value = self[self.top]
	self[self.top] = nil
	return value
end

function Stack:isEmpty()
	return self.top == 0
end

function Stack:flush()
	while not self:isEmpty() do
		self:pop()
	end
end

--[[
	Basic Map, can add key value pair, or remove by key.
]]
local Map = {}

function Map:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function Map:add(k, v)
	if(not k or not v) then
		print("Parameter Error")
	end
	self[k] = v
end

function Map:remove(k)
	self[k] = nil
end

Quadtree = {
	MAXDEPTH = 5,
	x = 0,
	y = 0,
	w = 0,
	h = 0
}

function Quadtree:new(x, y, w, h, d)
	o = {}
	setmetatable(o, self)
	self.__index = self

	o.nodes = {}
	o.entities = List:new()
	o.x = x
	o.y = y
	o.w = w
	o.h = h
	o.d = d or 0
	return o
end

function Quadtree:clear()
	for id, e in pairs(self.entities) do
		self.entities[id] = nil
	end

	for i, qt in pairs(self.nodes) do
		qt:clear()
		self.nodes[i] = nil
	end
end

function Quadtree:split()
	local x, y, w, h, d = self.x, self.y, self.w, self.h, self.d

	self.nodes[1] = Quadtree:new(x, y, w/2, h/2, d+1)
	self.nodes[2] = Quadtree:new(x+w/2, y, w/2, h/2, d+1)
	self.nodes[3] = Quadtree:new(x, y+h/2, w/2, h/2, d+1)
	self.nodes[4] = Quadtree:new(x+w/2, y+h/2, w/2, h/2, d+1)
end

function Quadtree:getIndex(x, y, w, h)
	local index = -1

	local vmidpoint = self.x + self.w/2
	local hmidpoint = self.y + self.h/2

	local topQuad = ((y < hmidpoint) and (y + h < hmidpoint))
	local botQuad = y >= hmidpoint

	if ((x < vmidpoint) and (x + w < vmidpoint)) then
		if topQuad then
			index = 2
		elseif botQuad then
			index = 3
		end
	elseif (x >= vmidpoint) then
		if topQuad then
			index = 1
		elseif botQuad then
			index = 4
		end
	end

	return index
end

function Quadtree:insert(e, x, y, w, h)
	local index = self:getIndex(x, y, w, h)
	if index == -1 then
		self.entities:add(e)
	else 
		if self.d == Quadtree.MAXDEPTH then
			self.entities:add(e)
		else
			if not self.nodes[index] then self:split() end
			self.nodes[index]:insert(e, x, y, w, h)
		end
	end
end

function Quadtree:retreive(x, y, w, h)
	local index = self:getIndex(x, y, w, h)
	local objs = {}

	if index ~= -1 and self.nodes[index] then
		objs = self.nodes[index]:retreive(x, y, w, h)
	end

	for id, entity in pairs(self.entities) do
		table.insert(objs, entity)
	end

	return objs
end




Util.List = List
Util.Queue = Queue
Util.Stack = Stack
Util.Map = Map
Util.Quadtree = Quadtree








-- General Functions

-- formatted printing use like C-style printf
printf = function(s,...)
	return io.write(s:format(...))
end

-- recursively prints all elements in a table
function printChildren(k, v, format, seen)
	seen = seen or {}
	format = format or ""
	if type(v) == "table" then
		if not seen[v] then
			printf(format .. "%s: %s\n", k, v)
			seen[v] = true
			for i, j in pairs(v) do 
				printChildren(i, j, format .."\t", seen)
			end
		else
			printf( format .. "duplicate %s %s\n", k, v)
		end
	else
		printf(format .. "%s: " .. "%s\n", k, v) 
	end
end

function deepCopy(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[deepCopy(orig_key)] = deepCopy(orig_value)
		end
		setmetatable(copy, deepCopy(getmetatable(orig)))
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

return Util

