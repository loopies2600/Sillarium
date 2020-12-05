extends KinematicBody2D

func getInputDirection():
	var inputDirection = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	return inputDirection
