extends StateMachine

func _ready():
	states_map = {
		"idle": $Idle,
		"walk": $Walk,
		"air": $Air,
		"bump": $Bump,
		"dash": $Dash
	}
	
func _change_state(state_name, msg := {} ):
	if not _active:
		return
	if state_name in ["bump", "locked"]:
		states_stack.push_front(states_map[state_name])
	._change_state(state_name, msg)
