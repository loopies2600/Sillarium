extends Node
class_name StateMachine

# warning-ignore:unused_signal
signal state_changed(current_state)

export(NodePath) var START_STATE
var states_map = {}

var states_stack = []
var current_state = null
var _active = false setget set_active

var firstConnection := true

func _ready():
	yield(owner, "ready")
	connectSignals()
	
func connectSignals():
	if !firstConnection:
		_disconnectEverything()
		
	var _unused
	if Objects.currentWorld:
		_unused = Objects.currentWorld.connect("level_started", self, "_levelStarted")
		_unused = Objects.currentWorld.connect("level_initialized", self, "_levelInitialized")
		
	if owner is Player:
		_unused = owner.connect("player_respawned", self, "_levelStarted")
	
	for child in get_children():
		child.connect("finished", self, "_change_state")
		
	firstConnection = false
		
func _disconnectEverything():
	if Objects.currentWorld:
		Objects.currentWorld.disconnect("level_started", self, "_levelStarted")
		Objects.currentWorld.disconnect("level_initialized", self, "_levelInitialized")
		
	if owner is Player:
		owner.disconnect("player_respawned", self, "_levelStarted")
	
	for child in get_children():
		child.disconnect("finished", self, "_change_state")
		
func _levelInitialized():
	set_active(false)
	
func _levelStarted():
	initialize(START_STATE)
	
func initialize(start_state, msg := {} ):
	set_active(true)
	states_stack.push_front(get_node(start_state))
	current_state = states_stack[0]
	current_state.enter(msg)

func set_active(value):
	_active = value
	set_physics_process(value)
	set_process(value)
	set_process_input(value)
	if not _active:
		states_stack = []
		current_state = null

func _input(event):
	if not _active:
		return
	current_state.handle_input(event)

func _process(delta):
	if not _active:
		return
	current_state.update(delta)
	
func _physics_process(delta):
	if not _active:
		return
	current_state.physics_update(delta)

func _change_state(state_name : String, msg := {} ) -> void:
	if not _active:
		return
	current_state.exit()
	
	if state_name == "previous":
		states_stack.pop_front()
	else:
		states_stack[0] = states_map[state_name]
	
	current_state = states_stack[0]
	
	if state_name != "previous":
		current_state.enter(msg)
