extends Node
class_name StateMachine, "machine.png"

var states = {}
var state = null setget setState
var previousState = null

onready var parent = get_parent()

func _physics_process(delta):
	if state != null:
		_stateLogic(delta)
		
		var transition = _getTransition(delta)
		
		if transition != null:
			setState(transition)
			
func _stateLogic(delta):
	pass
	
func _getTransition(delta):
	return null
	
func _enterState(new_state, old_state):
	pass
	
func _exitState(old_state, new_state):
	pass
	
func setState(new_state):
	previousState = state
	state = new_state
	
	if previousState != null:
		_exitState(previousState, new_state)
	if new_state != null:
		_enterState(new_state, previousState)
	
func addState(state_name):
	states[state.name] = states.size()
