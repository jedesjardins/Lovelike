--[[
	Contains the game states
]]

local states = {
	introState = {
		enter = function(self)
			-- load systems metadata
			local systems = require("systems")

			-- create engine
			self.engine = Engine:new()
			
			-- add the systems to the engine
			for k, v in pairs(systems) do 
				-- v is the actual system
				local sys = self.engine:newSystem(v.logic, v.kind)
				-- log the components it tracks
				self.engine:trackComponents(sys, v.comps)
			end

			-- creates and adds an entity
			id = self.engine:newEntity()

			-- creates and adds two components
			pos = {x = 10, y = 50}
			size = {w = 15, h = 30}
			self.engine:newComponent(pos, id, "pos")
			self.engine:newComponent(size, id, "size")

			id = self.engine:newEntity()

			pos = {x = 50, y = 50}
			size = {w = 15, h = 30}

			self.engine:newComponent(pos, id, "pos")
			self.engine:newComponent(size, id, "size")
			
		end,
		exit = function(self)
			--print("Exiting introState")
		end,
		update = function(self, dt, keys)
			self.engine:update(dt, keys)
			--print("Updating introState")
			--return "testState"
		end,
		draw = function(self)
			self.engine:draw()
		end
	},
	testState = {
		enter = function(self)
			--print("Entering testState")
			self.actor = {
				pos = {x = 100, y = 100},
				size = {w = 20, h = 20},
				vel = {x = 0, y = 0}
			}
		end,
		exit = function(self)
			--print("Exiting testState")
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