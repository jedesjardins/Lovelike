
--[[
	General Camera components 
]]

cameraPosition = Component:new()

function cameraPosition:update()
	if self.locked then 
		local x, y = self.getEntityXY()
		self.x = x - self.offsetX
		self.y = y - self.offsetY
	end
end

function cameraPosition:receive()

end

function cameraPosition:lockToEntity(entity, options)
	local pos = entity.components["position"]

	if pos then
		-- get closure
		self.getEntityXY = pos:getClosure({"x", "y"})
		local x, y = self.getEntityXY()
		if options == "center" then
			local wWidth, wHeight = love.graphics.getDimensions()
			local wFrame = entity.components["draw"]["frameW"]
			local hFrame = entity.components["draw"]["frameH"]
			self.offsetX = math.floor(wWidth/2 - wFrame/2)
			self.offsetY = math.floor(wHeight/2 - hFrame/2)
		else
			self.offsetX = x - self.x
			self.offsetY = y - self.y
		end
		self.locked = true
	else
		print("Entity has no position")
	end
end


--[[
	General player components
]]

basicInput = Component:new()

function basicInput:update(dt, keys, e)

	if keys["up"]	then
		local c = e:makeMoveCommand("up")
		c.Do()
	elseif keys["down"]	then 
		local c = e:makeMoveCommand("down")
		c.Do()
	end
	if keys["left"]	then 
		local c = e:makeMoveCommand("left")
		c.Do()
	elseif keys["right"] then 
		local c = e:makeMoveCommand("right")
		c.Do()
	end
	if keys["space"]then 
		local e2 = Entity:new(detective)

		e2.components["position"]["y"] = e.components["position"]["y"] + 100
		e2.components["position"]["x"] = e.components["position"]["x"] + 100
		e2:removeComponents({"input"})
		world:registerEntity(e2)
		-- create new entity
	end

	if not(keys["up"] or keys["down"] or keys["left"] or keys["right"]) then
		e:send{"move", "stand"}
	end
end

artificialInput = Component:new()

artificialInput.last = "left"
artificialInput.dur = 0
artificialInput.moveDuration = {
	up = 30, down = 30, left = 30, right = 30
}
artificialInput.nextMove = {
	up = "right", down = "left", left = "up", right = "down"
}

function artificialInput:update(dt, keys, e)
	if self.dur == self.moveDuration[self.last] then 
		self.dur = 0
		self.last = self.nextMove[self.last]
	end

	local c = e:makeMoveCommand(self.last)
	c.Do()
	self.dur = self.dur + 1
end

basicPosition = Component:new()

function basicPosition:receive(message)
	if message[1] == "nerf" then
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

personSprite = Component:new()

function personSprite:init(listOptions)
	Component.init(self, listOptions)

	self.image = love.graphics.newImage("resources/" .. listOptions["file"])
end

function personSprite:registerDepends(entity)

	self.getPosition = entity.components["position"]:getClosure({"x", "y"})
end

function personSprite:update()
	
	self.frame = self.frame + 1
end

function personSprite:draw()
	self.quad = self.quad or love.graphics.newQuad(0, 0, 24, 32, self.image:getDimensions())
	local x, y = self.getPosition()
	love.graphics.draw(self.image, self.quad, x, y)
end

function personSprite:receive(message)
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

basicLayer = Component:new()

basicStateMachine = Component:new()

function basicStateMachine:receive(message, e)
	if message[1] == "move" then
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

basicCollision = Component:new()

function basicCollision:registerDepends(entity)
	self.getPosition = entity.components["position"]:getClosure({"x", "y"})
end

function basicCollision:getBox()
	return self.x, self.y, self.w, self.h
end

function basicCollision:resolve(e1, e2)
	if not self.collide then return end 
	self:collide(e1, e2)
end

basicHands = Component:new()



itemPosition = Component:new()

function itemPosition:update()
	if self.locked then 
		local x, y = self.getEntityXY()
		self.x = x - self.offsetX
		self.y = y - self.offsetY
	end
end

function itemPosition:lockToEntity(entity, options)
	local pos = entity.components["position"]

	if pos then
		-- get closure
		self.getEntityXY = pos:getClosure({"x", "y"})
		local x, y = self.getEntityXY()
		if options == "center" then
			local wWidth, wHeight = love.graphics.getDimensions()
			local wFrame = entity.components["draw"]["frameW"]
			local hFrame = entity.components["draw"]["frameH"]
			self.offsetX = math.floor(wWidth/2 - wFrame/2)
			self.offsetY = math.floor(wHeight/2 - hFrame/2)
		else
			self.offsetX = x - self.x
			self.offsetY = y - self.y
		end
		self.locked = true
	else
		print("Entity has no position")
	end
end

itemSprite = Component:new()

function itemSprite:init(listOptions)
	Component.init(self, listOptions)

	self.image = love.graphics.newImage("resources/" .. listOptions["file"])
end

function itemSprite:registerDepends(entity)

	self.getPosition = entity.components["position"]:getClosure({"x", "y"})
end

function itemSprite:update()
	
end

function itemSprite:draw()
	local x, y = self.getPosition()
	love.graphics.draw(self.image, x, y)
end