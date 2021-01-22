extends State

export (int) var idleTimer = 5.0

var idleTime = idleTimer

func enter():
	owner.anim.play("Idle")
	idleTime = idleTimer
	
func update(delta):
	idleTime -= delta
	
	if idleTime <= 0:
		emit_signal("finished", "attack")
