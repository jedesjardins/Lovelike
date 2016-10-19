local introState = {}

function introState:enter()
	-- load systems metadata
	-- local systems = require("systems")

	-- create engine
	self.engine = Engine:new()
	
	-- add the systems to the engine
	for k, v in pairs(self.systems) do 
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
	con = {true}

	self.engine:newComponent(pos, id, "pos")
	self.engine:newComponent(size, id, "size")
	self.engine:newComponent(con, id, "control")
end

function introState:exit()
	--print("Exiting introState")
end

function introState:update(dt, keys)
	self.engine:update(dt, keys)
	--print("Updating introState")
	--return "nextState"
end

function introState:updateKeys()
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
	if love.keyboard.isDown("right") then
		keys["right"] = true
	end
	if love.keyboard.isDown("left") then
		keys["left"] = true
	end

	return keys
end

function introState:draw()
	self.engine:draw()
end

introState.systems = {
	movement = {
		kind = "update",
		comps = {"pos", "control"},
		logic = {
			update = function(self, dt, keys)
				if keys["down"] then
					for k, v in pairs(self["pos"]) do
						if self["control"][k] then
							v["y"] = v["y"] + 5
						end
					end
				end
				if keys["up"] then
					for k, v in pairs(self["pos"]) do
						if self["control"][k] then
							v["y"] = v["y"] - 5
						end
					end
				end
				if keys["left"] then
					for k, v in pairs(self["pos"]) do
						if self["control"][k] then
							v["x"] = v["x"] - 5
						end
					end
				end
				if keys["right"] then
					for k, v in pairs(self["pos"]) do
						if self["control"][k] then
							v["x"] = v["x"] + 5
						end
					end
				end
			end
		}
	},

	render = {
		kind = "draw",
		comps = {"pos", "size", "sprite"},
		logic = {
			draw = function(self)
				-- self["pos"] maps entity id to pos component

				for k, vPos in pairs(self["pos"]) do

					local vSize = self["size"][k]
					if vSize then
						local x = vPos["x"]
						local y = vPos["y"]
						local size = self["size"][k]
						local w = vSize["w"]
						local h = vSize["h"]

						love.graphics.rectangle("fill", x, y, w, h)
					end
				end
			end
		}
	}
}

return introState