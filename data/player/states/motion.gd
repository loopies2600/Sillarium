extends State

# Esto puede dar -1 (izquierda) o 1 (derecha)
func getInputDirection():
	var inputDirection = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	return inputDirection
