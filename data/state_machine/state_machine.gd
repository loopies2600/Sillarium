extends Node
class_name StateMachine, "machine.png"

signal stateChanged(current_state)

export (NodePath) var startingState
var statesMap = {}

var statesStack = []
var currentState = null
var _active = false setget setActive

func _ready():
	if !startingState:
		startingState = get_child(0).get_path()
	for child in get_children():
		var err = child.connect("finished", self, "_changeState")
		if err:
			printerr(err)
		
	initialize(startingState)
	
func initialize(initial_state):
	setActive(true)
	statesStack.push_front(get_node(initial_state))
	currentState = statesStack[0]
	currentState.enter()
	
func setActive(boolean : bool):
	_active = boolean
	set_physics_process(boolean)
	set_process_input(boolean)
	
	if !_active:
		statesStack = []
		currentState = null
	
func _unhandledInput(event):
	currentState.handleInput(event)
	
func _physics_process(delta):
	currentState.update(delta)
	
func _onAnimationFinished(anim_name):
	if !_active:
		return
	currentState._onAnimationFinished(anim_name)
	
func _changeState(state_name):
	if !_active:
		return
	currentState.exit()
	
	if state_name == "previous":
		statesStack.pop_front()
	else:
		statesStack[0] = statesMap[state_name]
		
	currentState = statesStack[0]
	emit_signal("stateCjanged", currentState)
	
	if state_name != "previous":
		currentState.enter()
