extends "motion.gd"

func enter():
	owner.snap = false
	owner.velocity.y = 0.0
	owner.velocity.y -= owner.jumpStrength
	
func update(delta):
	if getInputDirection():
		move(owner.maxSpeed, getInputDirection())
	else:
		cancelVelocity()
	
	if owner.is_on_floor():
		emit_signal("finished", "idle")
	
func exit():
	owner.snap = true
