extends "motion.gd"

func physics_update(_delta):
	owner.decelerate()
	owner.animspeedAsVelocity()
	
	if owner.getInputDirection():
		emit_signal("finished", "walk")
