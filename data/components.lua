inputComponent = Component:new()

function testInputComponent:update(dt, keys, e)
	if keys["down"] then e:send("move down") end
	if keys["up"] then e:send("move up") end
	if keys["left"] then e:send("move left") end
	if keys["right"] then e:send("move right") end
end

drawComponent = Component:new()

function testDrawComponent:draw()
	love.graphics.rectangle("fill", 0, 0, 10, 10)
end