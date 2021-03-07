extends "motion.gd"

func enter(_msg := {}):
	owner.animator.play("Idle")
	
func physics_update(delta):
	owner.animspeedAsVelocity()
	owner.moveAndSnap(delta)
	damp()
	
	if owner.getInputDirection():
		emit_signal("finished", "walk")
