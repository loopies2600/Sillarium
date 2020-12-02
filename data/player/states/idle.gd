extends "on_ground.gd"

func enter():
	owner.get_node("PlayerAnimator").play("Idle")
	
func update(_delta):
	var direction = getInputDirection()
	if direction:
		emit_signal("finished", "walk")
