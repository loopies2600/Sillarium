extends "motion.gd"

func enter():
	owner.snap = false
	owner.velocity.y = 0.0
	owner.velocity.y -= owner.jumpForce
	
func update(delta):
	if getInputDirection():
		move(owner.maxSpeed, getInputDirection())
	else:
		cancelVelocity()
		
		emit_signal("finished", "idle")
	
func exit():
	owner.snap = true
