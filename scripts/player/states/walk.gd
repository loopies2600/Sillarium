extends State

func physics_update(_delta):
	owner.animspeedAsVelocity()
	owner.checkPushables()
	owner.move()
	
	if !owner.getInputDirection():
		emit_signal("finished", "idle")
