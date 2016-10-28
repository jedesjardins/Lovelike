local introState = {}

function introState:enter()
	-- load systems metadata
	-- local systems = require("systems")

	-- create engine
	self.engine = Engine:new()

	-- add systems to the engine
	self.engine:addSystems(self.systems)

	-- add entities to the engine
	-- adds default camera
	self.engine:addEntity(self.entities["camera"])

	-- adds default player
	e = self.engine:addEntity(self.entities["player"])
	-- overwrites the previous position of the entity e (player)
	self.engine:newComponent({x = 0, y = 0}, e, "pos")
end

function introState:exit()

end

function introState:update(dt, keys)
	self.engine:update(dt, keys)
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
	self.engine:draw()
end

introState.systems = {
	camera = {
		kind = "update",
		comps = {"pos", "cam"},
		logic = {
			update = function(self, dt, keys)
				-- example camera transformation
				-- creates a constant left
				for id, cam in pairs(self["cam"]) do
					pos = self["pos"][id]
					pos["x"] = pos["x"] + 1

					x, y = pos["x"], pos["y"]

					--love.graphics.translate(-x, -y)
				end
			end
		}	
	},

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

	entityCollision = {
		kind = "update",
		comps = {"pos", "collision"},
		logic = {
			update = function(self, dt, keys)
			end
		}
	},

	render = {
		kind = "draw",
		comps = {"cam", "pos", "size", "sprite", "layer"}, -- sprite component will have sprite and layer
		logic = {
			draw = function(self)
				-- use: self["component name"] to get component list

				-- sort all drawable objects by layer
				local layersToId = {}
				local layers = {}

				-- place ids into specific layers
				for id, layerC in pairs(self["layer"]) do
					local layer = layerC[1]
					layersToId[layer] = layersToId[layer] or {}
					table.insert(layers, layer)
					table.insert(layersToId[layer], id)
				end

				-- sort layers so 
				table.sort(layers)

				for _, layer in ipairs(layers) do

					idTable = layersToId[layer]

					-- set camera, applies camera transformations
					self:set(self["pos"][1])

					-- draw all objects on layer, iterate
					for _, id in pairs(idTable) do 
						local pos = self["pos"][id]
						local sprite = self["sprite"][id]
						if pos and sprite then
							image = image or love.graphics.newImage("resources/" .. sprite["file"])

							fw, fh = sprite["frameSize"]["w"], sprite["frameSize"]["h"]
							iw, ih = image:getDimensions()


							quad = quad or love.graphics.newQuad(0, 0, fw, fh, iw, ih)

							x, y = pos["x"], pos["y"]
							love.graphics.draw(image, quad, x, y)
						end
					end

					-- removes camera transformations
					self:unset()
				end
			end,
			set = function(self, pos)
				-- pushes frame to graphics stack 
				love.graphics.push()
				-- translates camera position by x and y of camera
				love.graphics.translate(-pos["x"], -pos["y"])
			end,
			unset = function(self)
				love.graphics.pop()
			end
		}
	},
}

-- default entities
introState.entities = {
	camera = {
		cam = {},
		pos = {x = 0, y = 0}
	},
	player = {
		pos = {x = 50, y = 50},
		control = {true},
		collision = {tl = {}, tr = {}, bl = {}, br = {}},
		state = "down",
		sprite = {
			file = "Detective.png", 
			frameSize = {w = 24, h = 32}},
			frame = 0,
			stateToY = {
				down = 0,
				up = 1,
				left = 2,
				right = 3
		},
		layer = {1}
	}
}

-- keybinding matches action to keycode
introState.keyBinding = {
	up = "up",
	down = "down",
	left = "left",
	right = "right"
}

return introState