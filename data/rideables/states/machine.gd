extends StateMachine

func _ready():
	states_map = {
		"idle": $Idle,
		"walk": $Walk,
		"jump": $Jump
	}
