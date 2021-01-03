extends "motion.gd"

func enter():
	owner.velocity.x = 0.0
	owner.getNode("animator").play("Idle")
	
func update(delta):
	if getInputDirection():
		emit_signal("finished", "walk")
