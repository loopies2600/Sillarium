extends StateMachine

func _ready():
	states_map = {
		"idle": $Idle,
		"walk": $Walk,
		"jump": $Jump,
		"hold": $Hold
	}
	
func _change_state(state_name):
	if not _active:
		return
	if state_name in ["jump", "hold"]:
		states_stack.push_front(states_map[state_name])
	._change_state(state_name)
