
local StateManager = {}

function StateManager:init()
	require("State")
	require("Engine")
	require("InputHandler")
	require("Entity")
	require("Viewport")
	require("Map")
	require("Box")
	require("Point")

	self.state = require("state")
	self.state:enter()
end

function StateManager:update(dt)
	local nextState, saveFile = self.state:update(dt)
	if nextState then
		self:switchToState(nextState, saveFile)
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

return StateManager