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

sword = {
	position = {
		itemPosition,
		{x = 20, y = 40}
	},

	draw = {
		itemSprite,
		{
			dependencies = {position},
			file = "Sword.png",
			frameW = 3, frameH = 14
		}
	},

	layer = {
		basicLayer,
		{2}
	}
}

player = {
	hands = {
		basicHands,
		{
			
		}
	},
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
			h = 18,
			resolve = function(self, e1, e2)
				while not e1.commandQ:isEmpty() do
					local c = e1.commandQ:pop()
					c.Undo()
				end
			end
		}	
	},
	position = {
		basicPosition,
		{x = 0, y = 0}
	},
	draw = {
		personSprite,
		{
			dependencies = {position},
			file = "Detective.png",
			frame = 0, frameW = 24, frameH = 32,
			frameY = {down = 0, up = 1, left = 2, right = 3},
			frameX = {[0] = 0, [1] = 1, [2] = 0, [3] = 2}
		}	
	},
	layer = {
		basicLayer,
		{2}
	}
}

detective = {
	state = {
		basicStateMachine,
		{
			facing = "down",
			action = "stand"
		}
	},

	input = {
		artificialInput,
		{}
	},

	collision = {
		basicCollision,
		{
			x = 4,
			y = 10,
			w = 16,
			h = 18,
			resolve = function(self, e1, e2)
				while not e1.commandQ:isEmpty() do
					local c = e1.commandQ:pop()
					c.Undo()
				end
			end
		}	
	},

	position = {
		basicPosition,
		{x = 30, y = 30}
	},

	draw = {
		personSprite,
		{
			dependencies = {position},
			file = "Detective.png",
			frame = 0, frameW = 24, frameH = 32,
			frameY = {down = 0, up = 1, left = 2, right = 3},
			frameX = {[0] = 0, [1] = 1, [2] = 0, [3] = 2}
		}	
	},

	layer = {
		basicLayer,
		{2}
	}
}

camera = {
	position = {
		cameraPosition,
		{x = 0, y = 0}
	}
}