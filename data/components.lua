
playerInput = Component:new()

function playerInput:update(dt, keys, e)
	if keys["up"]	then e:send{"input", "up"}		end
	if keys["down"]	then e:send{"input", "down"}	end
	if keys["left"]	then e:send{"input", "left"}	end
	if keys["right"]then e:send{"input", "right"}	end

	if not(keys["up"] or keys["down"] or keys["left"] or keys["right"]) then
		e:send{"input", "stand"}
	end
end

position = Component:new()

function position:receive(message)
	if message[1] == "state" then
		if message[3] == "walk" then
			if message[2] == "up" then
				self.y = self.y - 2
			elseif message[2] == "down" then
			    self.y = self.y + 2
			elseif message[2] == "left" then
			    self.x = self.x - 2
			elseif message[2] == "right" then
			    self.x = self.x + 2
			end
		end
	end
end

drawSprite = Component:new()

function drawSprite:init(listOptions)
	Component.init(self, listOptions)

	self.image = love.graphics.newImage("resources/" .. listOptions["file"])
end

function drawSprite:registerDepends(entity)

	self.getPosition = entity.components["position"]:getClosure({"x", "y"})
end

function drawSprite:update()
	
	self.frame = self.frame + 1
end

function drawSprite:draw()
	self.quad = self.quad or love.graphics.newQuad(0, 0, 24, 32, self.image:getDimensions())
	local x, y = self.getPosition()
	love.graphics.draw(self.image, self.quad, x, y)
end

function drawSprite:receive(message)
	if message[1] == "state" then
		local facing = message[2]
		local action = message[3]

		local y = self.frameY[facing]

		-- TODO: memoize the quads
		if action == "stand" then
			self.frame = 0
			self.quad = love.graphics.newQuad(0, y*self.frameH, 
				self.frameW, self.frameH, 
				self.image:getDimensions())
		elseif action == "walk" then
			local x = self.frameX[math.floor(self.frame/6)%4]

			self.quad = love.graphics.newQuad(x*self.frameW, y*self.frameH, 
				self.frameW, self.frameH, 
				self.image:getDimensions())

		end
	end
end

playerStateMachine = Component:new()

function playerStateMachine:receive(message, e)
	if message[1] == "input" then
		-- stop moving
		if message[2] == "stand" then
			if self.action ~= "stand" then
				self.action = "stand"
				e:send{"state", self.facing, "stand"}
			end
		-- stay walking
		elseif message[2] == self.facing then
			self.action = "walk"
			e:send{"state", self.facing, "walk"}
		-- change directions
		else
			self.facing = message[2]
			e:send{"state", self.facing, self.action}
		end
	end
end