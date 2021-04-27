extends State

func physics_update(delta):
	owner.velocity.x = clamp(owner.velocity.x + (owner.accel * owner.direction), -owner.speed * 3, owner.speed * 3)
	owner.velocity.y *= owner.damping
	
	if !owner.onScreen:
		owner.queue_free()
