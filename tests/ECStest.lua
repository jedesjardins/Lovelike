


function runTests()
	testNewEngine()
	testNewSystem()
	testNewEntity()
	testNewComponent()
	testTrackComponent()
	testTrackBeforeAddComponent()
	testSystemLogic()
end

function testNewEngine()
	require("ECS")

	local engine = Engine:new()
	assert(engine.entities)
	assert(engine.components)
	assert(engine.updateSystems)
	assert(engine.drawSystems)
	print("Engine created successfully")

end

function testNewSystem()
	local engine = Engine:new()

	local uSystem = engine:newSystem({}, "update")
	local dSystem = engine:newSystem({}, "draw")

	-- assert newSystem returns references
	assert(uSystem)
	assert(dSystem)

	-- assert systems are inserted into engine
	assert(engine.updateSystems[1])
	assert(engine.drawSystems[1])

	-- assert systems returned are same as references in engine
	assert(engine.updateSystems[1] == uSystem)
	assert(engine.drawSystems[1] == dSystem)
	
	print("Systems added correctly")
end

function testNewEntity()
	local engine = Engine:new()

	local entity = engine:newEntity()

	-- assert newEntity returns id number
	assert(entity)

	-- assert systems are inserted into engine
	assert(engine.entities[entity])

	print("Entity added correctly")
end

function testNewComponent()
	local engine = Engine:new()
	local entity = engine:newEntity()
	local type = "pos"

	local pos = {x = 1, y = 2}

	local posComponent = engine:newComponent(pos, entity, type)

	-- assert component matches inserted list
	assert(posComponent["x"] == pos["x"])
	assert(posComponent["y"] == pos["y"])

	-- assert newComponent returns a reference
	assert(posComponent)

	-- assert this type of component list is added to engine
	assert(engine.components[type])

	-- assert this component was added to engine
	assert(engine.components[type][1])

	-- assert returned component was same as inserted to engine
	assert(engine.components[type][1] == posComponent)

	print("Component added correctly")
end

function testTrackComponent()
	local engine = Engine:new()
	local entity = engine:newEntity()
	local system = engine:newSystem({}, "update")
	local type = "pos"
	local posComponent = engine:newComponent(
							{x = 1, y = 2}, entity, type)

	engine:trackComponents(system, {type})

	-- assert the system component list for type is the same
	-- as the engine component list for type
	assert(system[type] == engine.components[type])

	print("Component tracked by system correctly")
end

function testTrackBeforeAddComponent()
	local engine = Engine:new()
	local entity = engine:newEntity()
	local system = engine:newSystem({}, "update")
	local type = "pos"

	engine:trackComponents(system, {type})

	-- assert the system component list for type is the same
	-- as the engine component list for type
	assert(system[type] == engine.components[type])

	print("Component tracked by system correctly without creating component")
end

function testSystemLogic()
	local engine = Engine:new()
	local entity = engine:newEntity()
	local temp = {
		update = function(self, dt)
			assert(self["pos"])
			print("update is working")
		end,
		draw = function(self)
			assert(self["pos"])
			print("draw is working")
		end
	}
	local system1 = engine:newSystem(temp, "update")
	local system2 = engine:newSystem(temp, "draw")
	local kind = "pos"
	local posComponent = engine:newComponent(
							{x = 1, y = 2}, entity, kind)

	engine:trackComponents(system1, {kind})
	engine:trackComponents(system2, {kind})

	-- printAllElements("system", system, "")

	-- assert the system component list for type is the same
	-- as the engine component list for type
	assert(system1[kind] == engine.components[kind])

	engine:update(0)
	engine:draw()

	--print("Component tracked by system correctly")
end