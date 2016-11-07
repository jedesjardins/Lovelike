
local StateManager = {}

function StateManager:init()
	-- self.states = require("states")
	-- self.state = self.states["introState"]
	require("State")
	self.state = require("tState")
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

function StateManager:updateKeys()
	return self.state:updateKeys()
end

return StateManager