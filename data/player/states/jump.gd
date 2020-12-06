extends "motion.gd"

func enter():
	owner.velocity.y -= owner.jumpStrength
	
func update(delta):
	if Input.is_action_just_pressed("dash"):
		emit_signal("finished", "dash")
	
	if owner.is_on_floor():
		emit_signal("finished", "idle")
		
	move(owner.speed, owner.acceleration, owner.maxSpeed, owner.getInputDirection())
