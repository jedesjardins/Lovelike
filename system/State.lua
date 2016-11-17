
State = {}

--[[
	Handles initialization of the state
	Should create the ECS, Map, Camera, and entities
]]
function State:enter()
	print("enter unimplimented")
end

--[[
	Handles freeing any memory and saving the state
]]
function State:exit()
	print("exit unimplimented")
end

--[[
	updates the state
	input:	dt:		time elapsed since last frame
			keys:	keypresses
	output:	next:	next state to transition to
]]
function State:update(dt, keys)
	print("update unimplimented")
	return nil
end

--[[
	tracks current keypresses
	output:	map of keys to action?
]]
function State:updateKeys()
	print("keys unimplimented")
	if love.keyboard.isDown("escape") then
		love.event.quit()
	end

	local keys = {}

	return keys
end

--[[
	draws the state
]]
function State:draw()
	print("draw unimplimented")
end

--[[
	Create new state
]]
function State:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

return State