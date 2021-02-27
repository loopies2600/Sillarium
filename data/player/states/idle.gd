extends "motion.gd"

func enter():
	owner.animator.play("Idle")
	
func update(delta):
	.update(delta)
	
	owner.animspeedAsVelocity()
	owner.moveAndSnap(delta)
	damp()
	
	if owner.getInputDirection():
		emit_signal("finished", "walk")
