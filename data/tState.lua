
local state = State:new()

function state:enter()
	require("Engine")

	engine = Engine:new()
	--camera = Camera:new()

	local entity = Entity:new()

	entity:addComponents(player)

	engine:registerEntity(entity)
end

function state:update(dt, keys)
	engine:update(dt, keys)
end

function state:draw()
	engine:draw()
end

function state:updateKeys()
	if love.keyboard.isDown("escape") then
		love.event.quit()
	end

	local keys = {}

	if love.keyboard.isDown("down") then keys["down"] = true end
	if love.keyboard.isDown("up") then keys["up"] = true end
	if love.keyboard.isDown("right") then keys["right"] = true end
	if love.keyboard.isDown("left") then keys["left"] = true end
	if love.keyboard.isDown("lctrl") then keys["lctrl"] = true end
	if love.keyboard.isDown("lshift") then keys["lshift"] = true end

	return keys
end

return state