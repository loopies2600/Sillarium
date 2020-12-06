extends "res://data/state_machine/state_machine.gd"

onready var idle = $Idle
onready var walk = $Walk
onready var jump = $Jump
onready var dash = $Dash

func _ready():
	states_map = { 
	"idle" : idle,
	"walk" : walk,
	"jump" : jump,
	"dash" : dash 
	}
	
	._ready()
