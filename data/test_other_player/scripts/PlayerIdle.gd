extends Node2D

var moveInputs = ["move_left", "move_right", "jump"]

func _ready():
	pass

func HandleInput(player, _delta):
	player.anim.animation = "Idle"
	player.head.animation = "Side"

	# Cambia el estado si hay input
	for currentInputs in moveInputs:
		if Input.is_action_pressed(currentInputs):
			return "Moving"
