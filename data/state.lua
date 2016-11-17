local state = State:new()

function state:enter()
	input = Input:new()
	engine = Engine:new()

	local viewport = Viewport:new()

	engine:registerViewPort(viewport)
end

function state:update(dt, keys)
	local keys = input:update()
	engine:update(dt, keys)
end

function state:draw()
	engine:draw()
end

--[[
function state:updateKeys()
	if love.keyboard.isDown("escape") then
		love.event.quit()
	end

	if love.keyboard.isDown("return") then keys["enter"] = true end
	if love.keyboard.isDown("rshift") then keys["shift"] = true end


	return keys
end
]]

return state