extends "motion.gd"

func enter(_msg := {}):
	pass
	
func physics_update(_delta):
	owner.damp()
	owner.animspeedAsVelocity()
	
	if owner.getInputDirection():
		emit_signal("finished", "walk")
