extends Node

# Hello
# Para variables globales

const UP = Vector2.UP
const MAX_FLOOR_ANGLE = 60
const UNIT_SIZE = 96

var player

onready var backgrounds = Settings.getSetting("renderer", "display_backgrounds")
onready var mute = Settings.getSetting("audio", "mute_audio")
onready var debug = Settings.getSetting("general", "debug_mode")

func LoadLevel(levelName):
	match levelName:
		"SalaGraciosa":
			var _unused = get_tree().change_scene("res://data/levels/test/puto_gordo_homosexual.tscn")
		"TestLevel":
			var _unused = get_tree().change_scene("res://data/levels/test/test_scene.tscn")
			
func LoadJSON(file, index):
	var jsonFile = File.new()
	jsonFile.open(file, File.READ)
	var parsed = JSON.parse(jsonFile.get_as_text())
	jsonFile.close()
	
	return parsed.result[str(index)]
