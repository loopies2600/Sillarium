extends "motion.gd"

func enter():
	owner.animator.play("Walking")
	
func update(delta):
	.update(delta)
	
	owner.animspeedAsVelocity()
	owner.moveAndSnap(delta)
	move(owner.maxSpeed, owner.getInputDirection())
	
	if not owner.getInputDirection():
		emit_signal("finished", "idle")
