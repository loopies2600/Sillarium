extends State

func enter(msg := {}):
	owner.snapVector = Vector2.ZERO
	
	if msg.has("isJump"):
		owner.doinJump = true
		owner.velocity.y = 0.0
		owner.velocity.y -= owner.jumpForce
		
func physics_update(_delta):
	owner.applyGravity = owner.coyotePeriod.is_stopped()
	owner.animspeedAsVelocity()
	
	if !owner.is_on_floor():
		if owner.getInputDirection():
			if Input.is_action_pressed("dash"):
				owner.move(owner.airMaxSpeed * 2)
			else:
				owner.move(owner.airMaxSpeed)
		else:
			owner.decelerate(owner.airDeceleration)
	else:
		emit_signal("finished", "idle")
		
func exit():
	owner.doinJump = false
	owner.canInput = true
	owner.displayTrails = false
	owner.snapVector = Vector2(0.0, Globals.MAX_FLOOR_ANGLE)
