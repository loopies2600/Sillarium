extends "res://data/player/states/motion.gd"

func enter():
	owner.animator.play("Idle")
	
func update(_delta):
	.update(_delta)
	
	damp()
	
	if owner.getInputDirection():
		emit_signal("finished", "walk")
