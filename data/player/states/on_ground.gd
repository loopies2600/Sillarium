extends "motion.gd"

func handleInput(event):
	if event.is_action_pressed("jump"):
		emit_signal("finished", "jump")
	return .handleInput(event)
