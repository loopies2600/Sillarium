extends StateMachine

onready var idle 
onready var walk 
onready var jump

func _ready():
	statesMap = {
			"idle" : idle,
			"walk" : walk,
			"jump" : jump
	}
