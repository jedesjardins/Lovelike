
player = {
	state = playerStateMachine:new{
		facing = "down",
		action = "stand",
		time = 0
	},
	input = playerInput:new(),
	draw = drawSprite:new{
		file = "Detective.png",
		frameW = 24, frameH = 32
	}
}