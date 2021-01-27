extends Node

const UP = Vector2.UP
const MAX_FLOOR_ANGLE = 60
const UNIT_SIZE = 96

var player

onready var debugOverlay = Objects.getObj(18)
onready var debug = Settings.getSetting("general", "debug_mode")

func debugSetup():
	if debug:
		debugOverlay.add_var("hero position (X, Y)", $Player, "position", false)
		debugOverlay.add_var("object count", self, "get_child_count", true)
		add_child(debugOverlay)
	
func LoadScene(sceneName):
	var newScene = LoadJSON("res://data/json/scenes.json", sceneName)["file"]
	get_tree().change_scene(newScene)
	
func LoadJSON(file, index):
	var jsonFile = File.new()
	jsonFile.open(file, File.READ)
	
	var parsed = JSON.parse(jsonFile.get_as_text())
	jsonFile.close()
	
	return parsed.result[str(index)]
