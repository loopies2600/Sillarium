extends Node

# Para variables globales

const UP = Vector2.UP
const UNIT_SIZE = 96
onready var trail = preload("res://scenes/Trail.tscn")
var debug = true

func loadLevel(levelName):
	match levelName:
		"SalaGraciosa":
			get_tree().change_scene("res://scenes/Levels/Test/TestRoom.tscn")
		"TestLevel":
			get_tree().change_scene("res://scenes/Levels/Test/TestScene.tscn")

func CreateTrail(fds, tex, pos, rot, z):
	var newTrail = trail.instance()
	get_tree().get_root().add_child(newTrail)
	newTrail.fadeSpeed = fds
	newTrail.texture = tex
	newTrail.global_position = pos
	newTrail.global_rotation = rot
	newTrail.z_index = z
