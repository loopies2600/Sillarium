extends "motion.gd"

func enter():
	owner.animator.play("Walking")
	
func update(_delta):
	move(owner.maxSpeed, getInputDirection())
	
	if not getInputDirection():
		emit_signal("finished", "idle")
