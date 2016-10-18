
local systems = {
	playerorders = {

	},

	movement = {
		kind = "update",
		comps = "pos",
		logic = {
			update = function(self, dt, keys)
				if keys["down"] then
					for k, v in pairs(self["pos"]) do
						v["y"] = v["y"] + 5
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

return systems