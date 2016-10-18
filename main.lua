function love.load()
	-- set up package paths
	package.path = "data/?.lua;" .. package.path
	package.path = "system/?.lua;" .. package.path
	package.path = "tests/?.lua;" .. package.path

	-- require game engine things
	state = require("State")
	require("Util")
	require("ECS")

	--[[
	--tests
	require("ECStest")
	runTests()
	]]

	state:init()
end

function love.update(dt)
	keys = state:getKeys()
	state:update(1, keys)
end

function love.draw()
	state:draw()
end
