extends "motion.gd"

func enter(msg := {}):
	owner.animator.play("Hold")
	
func handle_input(event):
	if event.is_action_released("input_hold"):
		emit_signal("finished", "idle")
	
