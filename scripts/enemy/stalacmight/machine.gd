extends StateMachine

func _ready():
	states_map = {
		"wait": $Wait,
		"fall": $Fall,
		"land": $Land
	}
	
func _change_state(state_name, msg := {} ):
	if not _active:
		return
	if state_name in ["fall"]:
		states_stack.push_front(states_map[state_name])
	._change_state(state_name, msg)
