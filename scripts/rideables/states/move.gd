extends "res://data/player/states/motion.gd"

func enter():
	owner.animator.play("Running")
	
func update(_delta):
	.update(_delta)
	
	move(owner.maxSpeed, owner.getInputDirection())
	
	if not owner.getInputDirection():
		emit_signal("finished", "idle")
