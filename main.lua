function love.load()
	-- set up package paths
	package.path = "data/?.lua;" .. package.path
	package.path = "system/?.lua;" .. package.path

	-- require game engine things
	state = require("State")

	state:init()
end

function love.update(dt)
	keys = state:getKeys()
	state:update(dt, keys)
end

function love.draw()
	state:draw()
end