extends State

func handle_input(event):
	if owner.is_on_floor():
		if event.is_action_pressed("jump"):
			emit_signal("finished", "jump")
		
func getInputDirection() -> int:
	var inputDirection = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	print(inputDirection)
	return inputDirection
	
func move(maxVel, direction):
	match direction:
		1.0:
			owner.velocity.x = min(owner.velocity.x + owner.acceleration, maxVel)
		-1.0:
			owner.velocity.x = max(owner.velocity.x - owner.acceleration, -maxVel)
	
func cancelVelocity():
	match sign(owner.velocity.x):
		1.0:
			owner.velocity.x = max(owner.velocity.x - owner.friction, 0.0)
		-1.0:
			owner.velocity.x = min(owner.velocity.x + owner.friction, 0.0)
