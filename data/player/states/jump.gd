extends "motion.gd"

func enter():
	owner.snap = false
	owner.velocity.y = 0.0
	owner.velocity.y -= owner.jumpForce
	
func update(delta):
	.update(delta)
	
	owner.animspeedAsVelocity()
	owner.moveAndSnap(delta)
	
	if !owner.is_on_floor():
		if owner.getInputDirection():
			move(owner.airMaxSpeed, owner.getInputDirection())
		else:
			damp()
	else:
		emit_signal("finished", "idle")
	
func exit():
	owner.snap = true
