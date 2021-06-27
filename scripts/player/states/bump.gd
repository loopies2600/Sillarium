extends State

func enter(msg := {}):
	owner.canInput = false
	
	owner.snapVector = Vector2.ZERO
	owner.velocity = Vector2.ZERO
	
	owner.velocity += Vector2(msg.bump.x, msg.bump.y)
	
	if msg.isDeadly:
		owner.kill()
		
	emit_signal("finished", "air")
