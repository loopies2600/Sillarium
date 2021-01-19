extends Node2D

onready var musicPlayer = preload("res://streams/music_player.tscn")
onready var debugOverlay = preload("res://debug/debug_overlay.tscn").instance()

export (int) var backgroundID
export (int) var musicID

func _ready():
	if Globals.backgrounds:
		_backgroundSetup(backgroundID)
	
	if !Globals.mute:
		_musicSetup(musicID)
	
	if Globals.debug:
		_debugSetup()
	
func _backgroundSetup(bgID):
	if (bgID != null):
		var background = load(Globals.LoadJSON("res://data/json/backgrounds.json", bgID)["file"])
		var newBackground = background.instance()
		add_child(newBackground)
		
func getMusicPeakVolume():
	var left = AudioServer.get_bus_peak_volume_left_db(0, 0)
	var right = AudioServer.get_bus_peak_volume_right_db(0, 0)
	
	return Vector2(left, right)
	
func _musicSetup(bgmID):
	if (bgmID != null):
		var music = musicPlayer.instance()
		music.stream = load(Globals.LoadJSON("res://data/json/music.json", str(bgmID))["file"])
		music.play()
		add_child(music)
		
		if getMusicPeakVolume() != Vector2(-200, -200):
			debugOverlay.add_var("music peak volume (left, right)", self, "getMusicPeakVolume", true)
		
func _debugSetup():
	debugOverlay.add_var("hero position (X, Y)", $Player, "position", false)
	debugOverlay.add_var("object count", self, "get_child_count", true)
	add_child(debugOverlay)
