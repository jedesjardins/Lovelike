
local state = State:new()

function state:enter()

	world = World:new()
	--camera = Camera:new()

	entity1 = Entity:new(detective)
	entity1.components["layer"][1] = 2
	entity2 = Entity:new(detective)
	entity2:removeComponents({"input"})
	--entity2.components["position"]["x"] = 100

	local cam = Entity:new(camera)

	cam.components["position"]:lockToEntity(entity1, "center")

	world:registerCamera(cam)
	world:registerEntity(entity1)
	world:registerEntity(entity2)
end

function state:update(dt, keys)
	world:update(dt, keys)
end

function state:draw()
	world:draw()
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
	if love.keyboard.isDown("w") then keys["w"] = true end
	if love.keyboard.isDown("a") then keys["a"] = true end
	if love.keyboard.isDown("s") then keys["s"] = true end
	if love.keyboard.isDown("d") then keys["d"] = true end

	if love.keyboard.isDown("lctrl") then keys["lctrl"] = true end
	if love.keyboard.isDown("lshift") then keys["lshift"] = true end

	return keys
end

return state