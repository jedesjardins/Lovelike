--[[
	Contains the game states
]]

local states = {
	introState = {
		enter = function(self)
			print("Entering introState")
		end,
		exit = function(self)
			print("Exiting introState")
		end,
		update = function(self, dt, keys)
			print("Updating introState")
			return "testState"
		end,
		draw = function(self)

		end
	},
	testState = {
		enter = function(self)
			print("Entering testState")
			self.actor = {
				pos = {x = 100, y = 100},
				size = {w = 20, h = 20},
				vel = {x = 0, y = 0}
			}
		end,
		exit = function(self)
			print("Exiting testState")
		end,
		update = function(self, dt, keys)
			if(keys["up"]) then
				self.actor.vel.y = self.actor.vel.y - 2 
			end
			if(keys["down"]) then
				self.actor.vel.y = self.actor.vel.y + 2 
			end
			if(keys["left"]) then
				self.actor.vel.x = self.actor.vel.x - 2 
			end
			if(keys["right"]) then
				self.actor.vel.x = self.actor.vel.x + 2 
			end

			self.actor.pos.x = self.actor.pos.x + self.actor.vel.x
			self.actor.pos.y = self.actor.pos.y + self.actor.vel.y

			if(self.actor.vel.x < 0) then
				self.actor.vel.x = self.actor.vel.x + 1
			elseif(self.actor.vel.x > 0) then
				self.actor.vel.x = self.actor.vel.x - 1
			end

			if(self.actor.vel.y < 0) then
				self.actor.vel.y = self.actor.vel.y + 1
			elseif(self.actor.vel.y > 0) then
				self.actor.vel.y = self.actor.vel.y - 1
			end

		end,
		draw = function(self)
			love.graphics.rectangle("fill", 
				self.actor.pos.x, self.actor.pos.y, 
				self.actor.size.w, self.actor.size.h)
		end
	},

	exitState = {
		enter = function(self)

		end,
		exit = function(self)

		end,
		update = function(self, dt, keys)

		end,
		draw = function(self)

		end
	}
}

return states