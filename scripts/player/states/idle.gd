extends "motion.gd"

func enter(_msg := {}):
	owner.animator.play("Idle")
	
func physics_update(delta):
	owner.damp()
	owner.animspeedAsVelocity()
	
	if owner.getInputDirection():
		emit_signal("finished", "walk")
