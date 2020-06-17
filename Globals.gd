extends Node

# Para variables globales

const UP = Vector2.UP
const UNIT_SIZE = 96
var debug = false

func loadLevel(levelName):
	match levelName:
		"SalaGraciosa":
			get_tree().change_scene("res://scenes/Levels/Test/TestRoom.tscn")
		"TestLevel":
			get_tree().change_scene("res://scenes/Levels/Test/TestScene.tscn")
