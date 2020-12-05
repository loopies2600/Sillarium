extends Node

# Para variables globales

const UP = Vector2.UP
const MAX_FLOOR_ANGLE = deg2rad(75)
const UNIT_SIZE = 96
onready var trail = preload("res://data/trail.tscn")
var debug = true

func LoadLevel(levelName):
	match levelName:
		"SalaGraciosa":
			get_tree().change_scene("res://data/levels/test/puto_gordo_homosexual.tscn")
		"TestLevel":
			get_tree().change_scene("res://data/levels/test/test_scene.tscn")

	
func CreateTrail(fds, tex, pos, rot, scl, z = 0):
	var newTrail = trail.instance()
	get_tree().get_root().add_child(newTrail)
	newTrail.fadeSpeed = fds
	newTrail.texture = tex
	newTrail.global_position = pos
	newTrail.global_rotation = rot
	newTrail.global_scale = scl
	newTrail.z_index = z

func LoadJSON(file, index):
	var jsonFile = File.new()
	jsonFile.open(file, File.READ)
	var parsed = JSON.parse(jsonFile.get_as_text())
	jsonFile.close()
	
	return parsed.result[str(index)]
