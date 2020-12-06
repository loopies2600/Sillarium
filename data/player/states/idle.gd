extends "res://data/state_machine/state.gd"

func enter():
	owner.get_node("Graphics/PlayerAnimator").play("Idle")
	
func handle_input(event):
	if event.is_action_pressed("jump"):
		if owner.is_on_floor():
			emit_signal("finished", "jump")
	
func update(_delta):
	owner.speed = lerp(owner.speed, 0.0, 0.5)
	
	if owner.getInputDirection():
		emit_signal("finished", "walk")
