local state = State:new()

function state:enter()
	input = Input:new()
	engine = Engine:new()

	local viewport = Viewport:new()
	local map = Map:new()

	engine:registerMap(map)
	engine:registerViewPort(viewport)
end

function state:update(dt, keys)
	local keys = input:update()
	engine:update(dt, keys)
end

function state:draw()
	engine:draw()
end

return state