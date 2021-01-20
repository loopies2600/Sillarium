extends "motion.gd"

func enter():
	owner.animator.play("Idle")
	
func update(delta):
	cancelVelocity()
	
	if getInputDirection():
		emit_signal("finished", "walk")
