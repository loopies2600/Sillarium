extends State

func enter(msg := {}):
	owner.anim.play("Attack")
	yield(owner.anim, "animation_finished")
	emit_signal("finished", "idle")
	
func update(_delta):
	if owner.isGrabbing:
		owner.currentBody.global_position = owner.tongueTip.global_position
		owner.currentBody.scale = owner.renderer.scale
