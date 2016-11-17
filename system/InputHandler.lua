Input = {}

function Input:new()
	local o = {}
	setmetatable(o, self)
	self.__index = self
	self.keys = {
		tracked = {"return", "rshift", "lshift", "up", "down", "left", "right"},
		pressed = function(keys, key)
			return keys[key] == "pressed"
		end,
		held = function(keys, key)
			return keys[key] == "held"
		end,
		released = function(keys, key)
			return keys[key] == "released"
		end
	}
	return o
end



function Input:update()
	if love.keyboard.isDown("escape") then
		love.event.quit()
	end

	local keys = self.keys

	for _, key in pairs(self.keys.tracked) do
		local isDown = love.keyboard.isDown(key)
		local state = keys[key]

		if not state then
			if isDown then 
				keys[key] = "pressed"
			end
		elseif state == "pressed" then
			if isDown then 
				keys[key] = "held"
			else 
				keys[key] = "released"
			end
		elseif state == "held" then
			if not isDown then 
				keys[key] = "released"
			end
		elseif state == "released" then
			if isDown then 
				keys[key] = "pressed"
			else 
				state = nil
			end
		end
	end

	return keys
end

--[[
function Input:update()
	-- TODO: don't quit on escape eventually
	if love.keyboard.isDown("escape") then
		love.event.quit()
	end

	local tracked = self.keys.tracked
	local pressed = self.keys.pressed
	local held = self.keys.held
	local released = self.keys.released

	for _, key in pairs(tracked) do
		local isDown = love.keyboard.isDown(key)
		released[key] = nil

		if isDown then
			-- key is down
			if pressed[key] or held[key]then
				-- key was already pressed
				pressed[key] = nil
				held[key] = true

				print(key, "held")
			else
				-- key was just pressed
				pressed[key] = true
				print(key, "pressed")
			end
		else
			-- key is not down
			if pressed[key] or held[key] then
				pressed[key] = nil
				held[key] = nil
				released[key] = true
				print(key, "released")
			else
				released[key] = nil
			end
		end
	end

	return self.keys
end
]]