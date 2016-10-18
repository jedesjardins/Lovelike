
local StateManager = {}

function StateManager:init()
	self.states = require("states")
	self.state = self.states["introState"]
	self.state:enter()
end

function StateManager:update(dt, keys)
	local nextState = self.state:update(dt, keys)
	if nextState then
		self:switchToState(nextState)
	end
end

function StateManager:draw()
	self.state:draw()
end

function StateManager:switchToState(nextState)
	self.state:exit()
	self.state = self.states[nextState]
	self.state:enter()
end

function StateManager:getKeys()
	local keys = {}
	
	if(love.keyboard.isDown("escape")) then
		love.event.quit()
	end
	if(love.keyboard.isDown("down")) then
		keys["down"] = true
	end

	return keys
end

return StateManager