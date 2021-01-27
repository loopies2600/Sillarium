extends Node

const UP = Vector2.UP
const MAX_FLOOR_ANGLE = 60
const UNIT_SIZE = 96

var currentBackground
var currentMusic

var player
var transition

onready var debugOverlay = Objects.getObj(18)

onready var backgrounds = Settings.getSetting("renderer", "display_backgrounds")
onready var mute = Settings.getSetting("audio", "mute_audio")
onready var debug = Settings.getSetting("general", "debug_mode")

func fade(mode = "in", mask = preload("res://sprites/debug/radius.png")):
	var newFade = Objects.getObj(20)
	transition = newFade
	newFade.mode = mode
	newFade.mask = mask
	get_tree().get_root().call_deferred("add_child", newFade)
	
func backgroundSetup(bgID):
	if backgrounds:
		if (bgID != null):
			var backgroundToLoad = load(LoadJSON("res://data/json/backgrounds.json", bgID)["file"])
			
			if currentBackground == null:
				var background = backgroundToLoad
				currentBackground = background.instance()
				add_child(currentBackground)
			else:
				currentBackground.queue_free()
				
			if currentBackground != backgroundToLoad:
				currentBackground.queue_free()
				var background = backgroundToLoad
				currentBackground = background.instance()
				add_child(currentBackground)
		
func getMusicPeakVolume():
	var left = AudioServer.get_bus_peak_volume_left_db(0, 0)
	var right = AudioServer.get_bus_peak_volume_right_db(0, 0)
	
	return Vector2(left, right)
	
func musicSetup(bgmID):
	if !mute:
		if (bgmID != null):
			var musicToLoad = load(LoadJSON("res://data/json/music.json", str(bgmID))["file"])
			
			if currentMusic == null:
				currentMusic = AudioStreamPlayer.new()
				currentMusic.stream = musicToLoad
				currentMusic.play()
				add_child(currentMusic)
				
			if currentMusic.stream != musicToLoad:
				currentMusic.stop()
				currentMusic.stream = load(LoadJSON("res://data/json/music.json", str(bgmID))["file"])
				currentMusic.play()
			
			if debug:
				if getMusicPeakVolume() != Vector2(-200, -200):
					debugOverlay.add_var("music peak volume (left, right)", self, "getMusicPeakVolume", true)
		
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
