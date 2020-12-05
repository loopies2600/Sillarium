extends StateMachine

func _ready():
	addState("idle")
	addState("walk")
	addState("jump")
	addState("fall")
	call_deferred("setState", states.idle)
	
func _unhandled_input(event):
	if [states.idle, states.run].has(state):
		if event.is_action_pressed("jump"):
			setState(states.jump)
	
func _stateLogic(delta):
	owner._handleInputs()
	owner._applyGravity(delta)
	owner._applyMovement(delta)
	
func _getTransition(delta):
	match state:
		
		states.idle:
			if !owner.is_on_floor():
				if owner.velocity.y < 0:
					return states.jump
				else:
					return states.fall
			elif owner.getInputDirection():
				return states.walk
				
		states.walk:
			if !owner.is_on_floor():
				if owner.velocity.y < 0:
					return states.jump
				else:
					return states.fall
			elif !owner.getInputDirection():
				return states.idle
				
		states.jump:
			if owner.is_on_floor():
				return states.idle
			elif owner.velocity.y > 0:
				return states.fall
				
		states.fall:
			if owner.is_on_floor():
				return states.idle
			elif owner.velocity.y < 0:
				return states.jump
				
	return null
