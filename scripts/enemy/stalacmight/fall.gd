extends State

func enter(_msg := {}):
	print("come on")
	owner.animator.play("Falling")
	owner.fell = true
	owner.applyGravity = true
	
func physics_update(_delta):
	var didHit = owner.raycast(32, "Environment")
	
	if didHit:
		emit_signal("finished", "land")
