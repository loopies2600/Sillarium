extends Node

# Hello
# Para variables globales

const UP = Vector2.UP
const MAX_FLOOR_ANGLE = 60
const UNIT_SIZE = 96
onready var trail = preload("res://data/generic/trail.tscn")

var player

onready var backgrounds = Settings.getSetting("renderer", "display_backgrounds")
onready var mute = Settings.getSetting("audio", "mute_audio")
onready var debug = Settings.getSetting("general", "debug_mode")

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
