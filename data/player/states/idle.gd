extends "motion.gd"

func enter():
	owner.animator.play("Idle")
	
func update(_delta):
	cancelVelocity()
	
	if owner.getInputDirection():
		emit_signal("finished", "walk")
