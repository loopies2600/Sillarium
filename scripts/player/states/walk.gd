extends State

func physics_update(_delta):
	owner.animspeedAsVelocity()
	owner.checkPushables()
	owner.move()
	
	if Input.is_action_pressed("dash"):
		emit_signal("finished", "run")
	
	if !owner.getInputDirection():
		emit_signal("finished", "idle")
