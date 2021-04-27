extends StateMachine

func _ready():
	states_map = {
		"attack": $Attack,
		"retreat": $Retreat
	}
	
func _change_state(state_name, msg := {}):
	if not _active:
		return
	if state_name in ["attack"]:
		states_stack.push_front(states_map[state_name])
	._change_state(state_name, msg)
