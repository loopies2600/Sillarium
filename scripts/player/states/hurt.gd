extends "motion.gd"

func enter(msg := {}):
	owner.canInput = false
	
	owner.snapVector = Vector2.ZERO
	owner.velocity = Vector2.ZERO
	
	owner.velocity += Vector2(msg.x, msg.y)
	
	if msg.isDeadly:
		owner.kill()
		
	emit_signal("finished", "air")
