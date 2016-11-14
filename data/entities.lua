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
		basicStateMachine,
		{
			facing = "down",
			action = "stand"
		}
	},

	input = {
		basicInput,
		{}
	},

	collision = {
		basicCollision,
		{
			x = 4,
			y = 10,
			w = 16,
			h = 18
		}	
	},

	position = {
		basicPosition,
		{
			x = 0, y = 0
		}
	},

	draw = {
		basicSprite,
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
		basicLayer,
		{
			2
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