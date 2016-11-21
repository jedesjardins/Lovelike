local state = State:new()

function state:enter()
	input = Input:new()
	engine = Engine:new()

	local map = Map:new()
	engine:addMap(map)

	local entity = Entity:new()
	engine:addEntity(entity)
end

function state:update(dt, keys)
	local keys = input:update()
	engine:update(dt, keys)
end

function state:draw()
	engine:draw()
end

return state