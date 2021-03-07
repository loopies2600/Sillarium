extends "motion.gd"

func enter(msg := {}):
	owner.snap = false
	
	if msg.has("isJump"):
		owner.velocity.y = 0.0
		owner.velocity.y -= owner.jumpForce
	
func physics_update(delta):
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
