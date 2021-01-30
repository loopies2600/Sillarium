extends "motion.gd"

func enter():
	owner.animator.play("Walking")
	
func update(_delta):
	.update(_delta)
	
	move(owner.maxSpeed, owner.getInputDirection())
	
	if not owner.getInputDirection():
		emit_signal("finished", "idle")
