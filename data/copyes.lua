
function findEntity(kind, subkind)

	if kind == "entity" then
		ret = entities[subkind]
	elseif kind == "camera" then
	    ret = cameras[subkind]
	elseif kind == "map" then
		ret = maps[subkind]
	end

	if ret then
		return ret
	else
		print("That type of entity does not exist", kind, subkind)
	end
end

function findSystem(kind)
	ret = systems[kind]

	if ret then
		return ret
	else
		print("That system does not exist", kind, subkind)
	end
end

--[[
	nil components are those that must be created when we make the enitity
	otherwise each entity will be affected by changes to other entities
]]
entities = {
	player = {
		pos = nil, --{x = 50, y = 50},
		state = {
			face = "left",
			action = "stand"
		},
		control = {true},
		sprite = {
			file = "Detective.png",
			frame = 0, 
			image = love.graphics.newImage("resources/" .. "Detective.png"),
			frameSize = {w = 24, h = 32},
			imageSize = {w = 72, h = 128},
			dirToY = {
				down = 0, up = 1, left = 2, right = 3
			},
			frameToX = {
				[0] = 0, [1] = 1, [2] = 0, [3] = 2
			}

		},
		layer = {2}
	}
}

cameras = {
	layered = {
		cam = {
			canvases = {},
			layers = {}
		},
		pos = {x = 0, y = 0}
	}
}

maps = {
	simple = {
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
	}
}

systems = {
	camera = {
		kind = "update",
		comps = {"pos", "cam"},
		logic = {
			update = function(self, dt, keys)
				-- example camera transformation
				-- creates a constant left
				for id, cam in pairs(self["cam"]) do
					pos = self["pos"][id]
					pos["x"] = pos["x"] - 1
				end
			end
		}	
	},

	playerStateFromInput = {
		kind = "update",
		comps = {"control", "state"},
		logic = {
			update = function(self, dt, keys)
				for id, control in pairs(self["control"]) do
					local oldState = self["state"][id]
					local potential
				end
			end
		}
	},

	spriteMovement = {
		kind = "update",
		comps = {"pos", "state"},
		logic = {
			update = function(self, dt, keys)
				for id, state in pairs(self["state"]) do
					if state["face"] == "down" and state["action"] == "walk" then
						local pos = self["pos"][id]
						pos["y"] = pos["y"] + 2.5
					end
				end
			end
		}
	},

	-- TODO: Optimize the loops finding controlable entities
	playerMovement = {
		kind = "update",
		comps = {"pos", "control", "state"},
		logic = {
			update = function(self, dt, keys)
				if keys["down"] then
					for k, v in pairs(self["pos"]) do
						if self["control"][k] then
							v["y"] = v["y"] + 2.5
							self["state"][k] = "down"
						end
					end
				end
				if keys["up"] then
					for k, v in pairs(self["pos"]) do
						if self["control"][k] then
							v["y"] = v["y"] - 2.5
							self["state"][k] = "up"
						end
					end
				end
				if keys["left"] then
					for k, v in pairs(self["pos"]) do
						if self["control"][k] then
							v["x"] = v["x"] - 2.5
							self["state"][k] = "left"
						end
					end
				end
				if keys["right"] then
					for k, v in pairs(self["pos"]) do
						if self["control"][k] then
							v["x"] = v["x"] + 2.5
							self["state"][k] = "right"
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
		comps = {"cam", "map", "pos"},
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

				-- TODO: Work with flexible 
				love.graphics.push()
				love.graphics.translate(-self["pos"][1]["x"], -self["pos"][1]["y"])
				love.graphics.draw(mapImage)
				love.graphics.pop()
			end
		}
	},

	renderSprites = {
		kind = "draw",		
		comps = {"cam", "sprite", "state", "pos", "layer"},
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

					-- initialize drawing
					local canvas = canvases[layer]
					love.graphics.setCanvas(canvas)
					love.graphics.push()
					love.graphics.translate(-self["pos"][1]["x"], -self["pos"][1]["y"])
					
					-- get the ids of entities on this layer
					local idTable = layersToId[layer]

					-- TODO: ensure entities have all required components
					for _, id in pairs(idTable) do 
						local pos = self["pos"][id]
						local sprite = self["sprite"][id]
						local state = self["state"][id]
						self:renderSprite(pos, sprite, state)
					end
					love.graphics.pop()
				end
			end,

			renderSprite = function(self, pos, sprite, state)
				if pos and sprite and state then
					local image = sprite["image"]
					local face = state["face"]
					local action = state["action"]

					local x = 0
					local y = sprite["dirToY"][face]
					local w, h = sprite["frameSize"]["w"], sprite["frameSize"]["h"]
					local iw, ih = sprite["imageSize"]["w"], sprite["imageSize"]["h"]

					local quad = love.graphics.newQuad(x*w, y*h, w, h, iw, ih)

					love.graphics.draw(image, quad, math.floor(pos["x"]), math.floor(pos["y"]))
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