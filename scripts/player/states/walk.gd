extends "motion.gd"

func physics_update(_delta):
	owner.animspeedAsVelocity()
	owner.checkPushables()
	owner.move()
	
	if not owner.getInputDirection():
		emit_signal("finished", "idle")
