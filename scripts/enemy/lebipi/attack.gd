extends State

func enter(_msg := {}):
	owner.anim.play("Jittering")

func physics_update(delta):
	owner.dirAccel += owner.seek()
	owner.velocity += owner.dirAccel * delta
	owner.velocity = owner.velocity.clamped(owner.speed)
	owner.target = Globals.player
	var didHit = owner.raycastPlayer()
	
	if didHit:
		owner.dropRock()
		yield(get_tree().create_timer(owner.idleTime), "timeout")
		emit_signal("finished", "retreat")
