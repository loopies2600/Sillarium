extends "motion.gd"

func enter():
	owner.getNode("animator").play("Idle")
	
func update(delta):
	cancelVelocity()
	
	if getInputDirection():
		emit_signal("finished", "walk")
