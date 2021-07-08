extends State

func enter(_msg := {}):
	owner.animator.play("Attack")
	yield(owner.animator, "animation_finished")
	emit_signal("finished", "idle")
	
func update(_delta):
	if owner.isGrabbing:
		owner.currentBody.global_position = owner.tongueTip.global_position
		owner.currentBody.scale = owner.renderer.scale
