extends "motion.gd"

func enter(_msg := {}):
	pass
	
func physics_update(_delta):
	owner.animspeedAsVelocity()
	owner.move()
	
	if not owner.getInputDirection():
		emit_signal("finished", "idle")
