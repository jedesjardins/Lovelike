
local testState = State:new()

function testState:enter()
	self.engine = Engine:new()

	-- add camera
	self.engine:addEntity(findEntity("camera", "layered"))

	self.engine:addSystem(findSystem("initLayers"))
	self.engine:addSystem(findSystem("clearLayers"))
	self.engine:addSystem(findSystem("renderLayers"))

	-- add map
	self.engine:addEntity(findEntity("map", "simple"))

	self.engine:addSystem(findSystem("renderMap"))

	-- add sprites
	e = self.engine:addEntity(findEntity("entity", "player"))
	self.engine:newComponent({x = 0, y = 0}, e, "pos")

	self.engine:addSystem(findSystem("renderSprites"))
	self.engine:addSystem(findSystem("playerStateFromInput"))
	-- self.engine:addSystem(findSystem("spriteMovement"))

	self.engine:sortSystems()
end

function testState:update(dt, keys)
	self.engine:update(dt, keys)
end

function testState:updateKeys()
	if love.keyboard.isDown("escape") then
		love.event.quit()
	end

	local keys = {}

	if love.keyboard.isDown("down") then
		keys["down"] = true
	end
	if love.keyboard.isDown("up") then
		keys["up"] = true
	end
	if love.keyboard.isDown("left") then
		keys["left"] = true
	end
	if love.keyboard.isDown("right") then
		keys["right"] = true
	end

	return keys
end

function testState:draw()
	self.engine:draw()
end


return testState
