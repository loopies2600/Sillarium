extends "motion.gd"

func enter():
	owner.getNode("animator").play("Hold")
	
func handle_input(event):
	if event.is_action_released("input_hold"):
		emit_signal("finished", "idle")
		
func update(delta):
	cancelVelocity()
	
	owner.weapon.setFiringDirection(delta)
