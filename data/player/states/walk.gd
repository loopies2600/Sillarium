extends "motion.gd"

func enter():
	owner.get_node("Graphics/PlayerAnimator").play("Walking")

func update(delta):
	if !owner.getInputDirection():
		emit_signal("finished", "idle")
		
	move(owner.speed, owner.acceleration, owner.maxSpeed, owner.getInputDirection())
	
	if Input.is_action_pressed("jump"):
		if owner.is_on_floor():
			emit_signal("finished", "jump")
