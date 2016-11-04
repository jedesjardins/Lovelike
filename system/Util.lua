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
	-- o.size = 0
	return o
end

function List:add(o)
	local i = #self + 1
	self[i] = o or true
	-- self.size = self.size + 1
	return i
end

function List:remove(i)
	if not i then
		print("Parameter Error")
		return
	end

	self[i] = nil
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

Util.List = List
Util.Map = Map

-- General Functions

-- formatted printing use like C-style printf
printf = function(s,...)
	return io.write(s:format(...))
end

-- recursively prints all elements in a table
function printAllElements(k, v, format)
	if not format then
		format = ""
	end
	if type(v) == "table" then
		printf(format .. "%s: %s\n", k, v)
		for i, j in pairs(v) do 
			printAllElements(i, j, format .."\t")
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

