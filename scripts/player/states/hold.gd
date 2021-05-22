extends "motion.gd"

func enter(_msg := {}):
	pass
	
func physics_update(_delta):
	owner.decelerate()
	owner.animspeedAsVelocity()
	
func handle_input(event):
	if event.is_action_released("input_hold" + owner.inputSuffix):
		emit_signal("finished", "idle")
