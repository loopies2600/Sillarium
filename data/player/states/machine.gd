extends StateMachine

func _ready():
	states_map = {
		"idle": $Idle,
		"walk": $Walk,
		"jump": $Jump,
		"dash": $Dash
	}
	
func _change_state(state_name):
	if not _active:
		return
	if state_name in ["jump", "dash"]:
		states_stack.push_front(states_map[state_name])
	._change_state(state_name)
