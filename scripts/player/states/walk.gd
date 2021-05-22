extends "motion.gd"

func physics_update(_delta):
	owner.animspeedAsVelocity()
	owner.checkPushables()
	
	if Input.is_action_pressed("dash"):
		owner.move(owner.maxSpeed * 2)
	else:
		owner.move()
	
	if !owner.getInputDirection():
		emit_signal("finished", "idle")
	else:
		if sign(owner.velocity.x) != owner.getInputDirection() && abs(owner.velocity.x) > owner.maxSpeed:
			owner.graphics.rotation = 0.1 * -sign(owner.velocity.x)
		else:
			owner.graphics.rotation = 0
