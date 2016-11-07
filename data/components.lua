testInputComponent = Component:new()

testInputComponent.listening = true

function testInputComponent:update(dt, keys, e)
	if self.listening then
		if keys["down"] then e:send("move down") end
		if keys["up"] then e:send("move up") end
		if keys["left"] then e:send("move left") end
		if keys["right"] then e:send("move right") end
		if keys["lshift"] then e:send("stop listening") end
		if keys["lctrl"] then e:send("stop drawing") end
	end
end

function testInputComponent:receive(message)
	if message == "stop listening" then
		self.listening = false
	end
end

playerInput = Component:new()

function playerInput:update(dt, keys, e)
	if keys["up"]	then e:send{"input", "up"}		end
	if keys["down"]	then e:send{"input", "down"}	end
	if keys["left"]	then e:send{"input", "left"}	end
	if keys["right"]then e:send{"input", "right"}	end
	if not(keys["up"] or keys["down"] or keys["left"] or keys["right"]) then
		e:send{"input", "stop"}
	end

end

drawSprite = Component:new()

function drawSprite:init(listOptions)
	Component.init(self, listOptions)

	self.image = love.graphics.newImage("resources/" .. listOptions["file"])
end

function drawSprite:draw()
	self.quad = self.quad or love.graphics.newQuad(0, 0, 24, 32, self.image:getDimensions())
	love.graphics.draw(self.image, self.quad)
end

function drawSprite:receive(message)
	if type(message) ~= "table" then
		print(message)
	end
end

playerStateMachine = Component:new()

function playerStateMachine:receive(message, e)
	if message[1] == "input" then
		-- stop moving
		if message[2] == "stop" then
			self.action = "stand"
			self.time = 0
		-- stay walking
		elseif message[2] == self.facing then
			self.action = "walk"
			self.time = self.time + 1
		-- change directions
		else
			self.facing = message[2]
			self.action = "walk"
			self.time = 0
		end
	end

end