extends "res://data/state_machine/state.gd"

func move(speed, acceleration, max_speed, direction):
	owner.speed = clamp(speed + acceleration * direction, -max_speed, max_speed)
	
	if direction != 0:
		owner._getNode("parent_sprite").scale.x = direction
