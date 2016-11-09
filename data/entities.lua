--[[
	entity must be defined as such

	<entity name> = {
		<component name> = {
			<component class>,
			{
				<parameters
			}
		},	
	}
]]

detective = {
	state = {
		playerStateMachine,
		{
			facing = "down",
			action = "stand"
		}
	},

	input = {
		playerInput,
		{}
	},

	position = {
		position,
		{
			x = 10, y = 10
		}
	},

	draw = {
		drawSprite,
		{
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
	},

	layer = {
		layerSprite,
		{
			1
		}
	}
}

camera = {
	position = {
		cameraPosition,
		{
			x = 0, y = 0
		}
	}
}