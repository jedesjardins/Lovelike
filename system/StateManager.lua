
local StateManager = {}

function StateManager:init()
	-- self.states = require("states")
	-- self.state = self.states["introState"]
	require("State")
	require("Engine")
	require("InputHandler")
	require("Viewport")

	self.state = require("state")
	self.state:enter()
end

function StateManager:update(dt)
	local nextState = self.state:update(dt)
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

--[[
function StateManager:updateKeys()
	return self.state:updateKeys()
end
]]

return StateManager