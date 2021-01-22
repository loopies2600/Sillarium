extends State

func emter():
	var _unused = connect("recoilPlayer", self, "_doRecoil")
	
func handle_input(event):
	if owner.is_on_floor():
		if event.is_action_pressed("jump"):
			emit_signal("finished", "jump")
		if event.is_action_pressed("input_hold"):
			emit_signal("finished", "hold")
		
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
