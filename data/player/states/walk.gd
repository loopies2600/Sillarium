extends "motion.gd"

func enter(msg := {}):
	owner.animator.play("Walking")
	
func physics_update(delta):
	owner.animspeedAsVelocity()
	owner.moveAndSnap(delta)
	move(owner.maxSpeed, owner.getInputDirection())
	
	if not owner.getInputDirection():
		emit_signal("finished", "idle")
