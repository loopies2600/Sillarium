extends "motion.gd"

func physics_update(_delta):
	owner.animspeedAsVelocity()
	owner.checkPushables()
	owner.move(owner.maxSpeed * 2)
	
	if Input.is_action_just_released("dash"):
		emit_signal("finished", "walk")
	
	if !owner.getInputDirection():
		emit_signal("finished", "idle")
