extends State

func enter(_msg := {}):
	owner.animator.play("WaitingTop")

func physics_update(_delta):
	var didHit = owner.raycast()
	
	if didHit:
		yield(get_tree().create_timer(owner.idleTime), "timeout")
		emit_signal("finished", "fall")
