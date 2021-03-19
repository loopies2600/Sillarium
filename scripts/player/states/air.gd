extends "motion.gd"

func enter(msg := {}):
	owner.snapVector = Vector2.ZERO
	
	if msg.has("isJump"):
		owner.velocity.y = 0.0
		owner.velocity.y -= owner.jumpForce
	
func physics_update(delta):
	owner.animspeedAsVelocity()
	
	if !owner.is_on_floor():
		if owner.getInputDirection():
			owner.move(owner.airMaxSpeed)
		else:
			owner.damp(owner.airFriction)
	else:
		owner.canInput = true
		emit_signal("finished", "idle")
		
func exit():
	owner.snapVector = Vector2(0.0, Globals.MAX_FLOOR_ANGLE)
