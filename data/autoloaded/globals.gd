extends Node

const UP = Vector2.UP
const MAX_FLOOR_ANGLE = 60
const UNIT_SIZE = 96

var player
var transition

onready var backgrounds = Settings.getSetting("renderer", "display_backgrounds")
onready var mute = Settings.getSetting("audio", "mute_audio")
onready var debug = Settings.getSetting("general", "debug_mode")

func fade(mode = "in", mask = preload("res://sprites/debug/radius.png")):
	var newFade = Objects._getObj(20)
	transition = newFade
	newFade.mode = mode
	newFade.mask = mask
	get_tree().get_root().call_deferred("add_child", newFade)
	
func LoadLevel(levelName):
	match levelName:
		"MainMenu":
			var _unused = get_tree().change_scene("res://data/ui/menu/main_menu/main_menu.tscn")
		"SoundTest":
			var _unused = get_tree().change_scene("res://debug/sound_test.tscn")
		"TestTutorial":
			var _unused = get_tree().change_scene("res://data/levels/test/test_tutorial.tscn")
		"SalaGraciosa":
			var _unused = get_tree().change_scene("res://data/levels/test/puto_gordo_homosexual.tscn")
		"EnemyTest":
			var _unused = get_tree().change_scene("res://data/levels/test/enemy_test.tscn")
		"TestLevel":
			var _unused = get_tree().change_scene("res://data/levels/test/test_scene.tscn")
			
func LoadJSON(file, index):
	var jsonFile = File.new()
	jsonFile.open(file, File.READ)
	
	var parsed = JSON.parse(jsonFile.get_as_text())
	jsonFile.close()
	
	print(file, " loaded.")
	return parsed.result[str(index)]
