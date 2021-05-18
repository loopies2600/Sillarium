extends "motion.gd"

func physics_update(_delta):
	owner.animspeedAsVelocity()
	owner.checkPushables()
	
	if Input.is_action_pressed("dash"):
		owner.move(owner.maxSpeed * 2)
	else:
		owner.move()
	
	if not owner.getInputDirection():
		emit_signal("finished", "idle")
