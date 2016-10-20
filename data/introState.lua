local introState = {}

function introState:enter()
	-- load systems metadata
	-- local systems = require("systems")

	-- create engine
	self.engine = Engine:new()

	-- add systems to the engine
	self.engine:addSystems(self.systems)

	-- add entities to the engine
	self.engine:addEntities(self.entities)

	-- camera shit
	self.camera = Camera:new()
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

	if love.keyboard.isDown(self.keyBinding["down"]) then
		keys["down"] = true
	end
	if love.keyboard.isDown(self.keyBinding["up"]) then
		keys["up"] = true
	end
	if love.keyboard.isDown(self.keyBinding["right"]) then
		keys["right"] = true
	end
	if love.keyboard.isDown(self.keyBinding["left"]) then
		keys["left"] = true
	end

	return keys
end

function introState:draw()
	self.camera:set()
	self.engine:draw()
	self.camera:unset()
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
		comps = {"pos", "size", "sprite", "layer"}, -- sprite component will have sprite and layer
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

						local filePath = "resources/" .. self["sprite"][k]["file"]
						image = image or love.graphics.newImage("resources/" .. self["sprite"][k]["file"])

						quad = quad or love.graphics.newQuad(0, 0, 24, 32, 72, 128)

						love.graphics.draw(image, quad, x, y)
						-- love.graphics.rectangle("fill", x, y, w, h)
					end
				end
			end
		}
	}
}

introState.entities = {
	camera = {
		cam = {},
		pos = {0, 0}
	},
	player = {
		pos = {x = 100, y = 100},
		size = {w = 15, h = 15},
		control = {true},
		sprite = {file = "Detective.png"}
	}
	--[[,
	enemy = {
		pos = {x = 10, y = 10},
		size = {w = 30, h = 30}
	}
	]]
}

introState.keyBinding = {
	up = "up",
	down = "down",
	left = "left",
	right = "right"
}

return introState