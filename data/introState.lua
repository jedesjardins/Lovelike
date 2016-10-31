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
	self.engine:addEntity(self.entities["fixedmap"])

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
							v["y"] = v["y"] + 2.5
						end
					end
				end
				if keys["up"] then
					for k, v in pairs(self["pos"]) do
						if self["control"][k] then
							v["y"] = v["y"] - 2.5
						end
					end
				end
				if keys["left"] then
					for k, v in pairs(self["pos"]) do
						if self["control"][k] then
							v["x"] = v["x"] - 2.5
						end
					end
				end
				if keys["right"] then
					for k, v in pairs(self["pos"]) do
						if self["control"][k] then
							v["x"] = v["x"] + 2.5
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

	--[[
		INITIALIZATION FUNCTIONS
	]]
	initLayers = {
		kind = "init",
		comps = {"cam", "layer"},
		logic = {
			init = function(self)
				local canvases = self["cam"][1]["canvases"]
				local layers = {}

				for id, layerC in pairs(self["layer"]) do
					local layer = layerC[1]
					layers[layer] = true
				end

				for layer, _ in pairs(layers) do 
					canvases[layer] = love.graphics.newCanvas(800, 600)
				end

			end
		}
	},

	--[[
		DRAWING FUNCTIONS
	]]
	clearLayers = {
		kind = "draw",
		comps = {"cam"},
		logic = {
			priority = 1,
			draw = function(self)
				local canvases = self["cam"][1]["canvases"]

				for _, canvas in pairs(canvases) do
					love.graphics.setCanvas(canvas)
					love.graphics.clear()
				end
			end
		}	
	},

	renderMap = {
		kind = "draw",
		comps = {"cam", "map"},
		logic = {
			draw = function(self)
				local cam = self["cam"][1]
				local map = self["map"][2]

				if not map["canvas"] then
					map["tilesheet"]["image"] = love.graphics.newImage("resources/" .. map["tilesheet"]["file"])
					
					local tilesheet = map["tilesheet"]["image"]

					--TODO: change size of the canvas to something in terms of the map
					map["canvas"] = love.graphics.newCanvas(800, 600)
					local canvas = map["canvas"]	

					local w, h = tilesheet:getDimensions()

					love.graphics.setCanvas(canvas)

					for y, row in pairs(map["tiles"]) do
						for x, val in pairs(row) do
							local tile = map["tiles"][y][x]
							local quad = map["tilesheet"]["quads"][tile]
							love.graphics.draw(tilesheet, quad, (x-1)*24, (y-1)*24)

						end
					end
				end

				mapImage = map["canvas"]

				screen = cam["canvases"][4]

				love.graphics.setCanvas(screen)
				love.graphics.draw(mapImage)
			end
		}
	},

	renderSprites = {
		kind = "draw",		
		comps = {"cam", "sprite", "pos", "layer"},
		logic = {
			draw = function(self)

				-- sort all drawable objects by layer
				local layersToId = {}	-- maps each layer to lists of
				local allLayers = {}

				-- place ids into specific layers
				for id, layerC in pairs(self["layer"]) do
					local layer = layerC[1]
					layersToId[layer] = layersToId[layer] or {}
					allLayers[layer] = true
					table.insert(layersToId[layer], id)
				end

				local layers = {}

				for layer, _ in pairs(allLayers) do
					table.insert(layers, layer)
				end

				table.sort(layers)

				local canvases = self["cam"][1]["canvases"]

				-- create a canvas for each layer
				for _, layer in pairs(layers) do
					local canvas = canvases[layer]

					love.graphics.setCanvas(canvas)


					idTable = layersToId[layer]

					for _, id in pairs(idTable) do 
						local pos = self["pos"][id]
						local sprite = self["sprite"][id]
						if pos and sprite then
							sprite["image"] = sprite["image"] or love.graphics.newImage("resources/" .. sprite["file"])
							local image = sprite["image"]

							fw, fh = sprite["frameSize"]["w"], sprite["frameSize"]["h"]
							iw, ih = image:getDimensions()


							quad = quad or love.graphics.newQuad(0, 0, fw, fh, iw, ih)

							x, y = pos["x"], pos["y"]
							love.graphics.draw(image, quad, x, y)
						end
					end

					love.graphics.setCanvas()
					love.graphics.draw(canvas)
				end
			end
		}
	},

	renderLayers = {
		kind = "draw",
		priority = 3,
		comps = {"cam", "layer"},
		logic = {
			priority = 3,
			draw = function(self)

				-- TODO: track layers somehow? this is sloppy

				-- sort all drawable objects by layer
				local layersToId = {}	-- maps each layer to lists of
				local allLayers = {}

				-- place ids into specific layers
				for id, layerC in pairs(self["layer"]) do
					local layer = layerC[1]
					layersToId[layer] = layersToId[layer] or {}
					allLayers[layer] = true
					table.insert(layersToId[layer], id)
				end

				local layers = {}

				for layer, _ in pairs(allLayers) do
					table.insert(layers, layer)
				end

				table.sort(layers)

				--TODO: after tracking layers correctly, this is all that's left

				local canvases = self["cam"][1]["canvases"]

				love.graphics.setCanvas()

				for _, layer in pairs(layers) do
					local canvas = canvases[layer]
					love.graphics.draw(canvas)
				end
			end
	
		}
	}
}

-- default entities
introState.entities = {
	camera = {
		cam = {
			canvases = {},
			layers = {}
		},
		pos = {x = 0, y = 0}
	},

	fixedmap = {
		map = {	
			tiles = {							-- background map data
				{0,0,0,0,0,0,0,0},
				{0,1,1,1,1,1,1,0},
				{0,1,1,1,1,1,1,0},
				{0,1,1,1,1,1,1,0},
				{0,1,1,1,1,1,1,0},
				{0,1,1,1,1,1,1,0},
				{0,1,1,1,1,1,1,0},
				{0,0,0,0,0,0,0,0},
			},							
			canvas = nil,						-- permanent image representing map
			tilesheet = {						-- holds the image data of the tileset
				image = nil,
				quads = {
					[0] = love.graphics.newQuad(0, 0, 24, 24, 240, 240),
					[1] = love.graphics.newQuad(24, 0, 24, 24, 240, 240)
				},					
				file = "Tileset.png",			-- file path
				frameSize = {w = 24, h = 24}	-- size of a frame
			}
		},
		layer = {1}
	},

	-- TODO: should images and objects for entitiesbe loaded here?
	-- That way all objects can share image, default quads, etc.
	player = {
		pos = {x = 50, y = 50},
		control = {true},
		collision = {tl = {}, tr = {}, bl = {}, br = {}},
		state = "down",
		sprite = {
			image = nil,
			quads = nil,
			file = "Detective.png", 
			frameSize = {w = 24, h = 32},
			frame = 0,
			stateToY = {
				down = 0,
				up = 1,
				left = 2,
				right = 3
			}
		},
		layer = {3}
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