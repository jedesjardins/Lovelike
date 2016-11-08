--[[
player2 = {
	state = {
		playerStateMachine.new,
		{
			face = "down",
			action = "stand"
		}
	}
}
]]

player = {
	state = playerStateMachine:new{
		face = "down",
		action = "stand"
	},

	input = playerInput:new(),

	position = position:new{
		x = 0, y = 0
	},

	draw = drawSprite:new{
		dependencies = {position},
		file = "Detective.png",
		frame = 0,
		frameW = 24, frameH = 32,
		frameY = {
			down = 0,
			up = 1,
			left = 2,
			right = 3
		},
		frameX = {
			[0] = 0,
			[1] = 1,
			[2] = 0,
			[3] = 2
		}	
	}
}