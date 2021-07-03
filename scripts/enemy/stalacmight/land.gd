extends State

func enter(_msg := {}):
	owner.fell = false
	owner.animator.play("Landing")
	owner.emit_signal("camera_shake_requested")
	yield(get_tree().create_timer(owner.idleTime * 2), "timeout")
	owner.z_index = 0
	owner.animator.play("GettingUp")
