extends Node2D

onready var musicPlayer = preload("res://streams/MusicPlayer.tscn")
onready var debugOverlay = preload("res://debug/DebugOverlay.tscn").instance()
onready var Definitions = preload("res://scenes/Definitions.gd").new()
export (int) var backgroundID
export (int) var musicID

func _ready():
	_backgroundSetup(backgroundID)
	_musicSetup(musicID)
	
	if Globals.debug:
		_debugSetup()
	
func _backgroundSetup(bgID):
	if (bgID != null):
		var background = Definitions.BG[bgID].instance()
		add_child(background)
	
func getMusicPeakVolume():
	var left = AudioServer.get_bus_peak_volume_left_db(0, 0)
	var right = AudioServer.get_bus_peak_volume_right_db(0, 0)
	
	return Vector2(left, right)
	
func _musicSetup(bgmID):
	if (bgmID != null):
		var music = musicPlayer.instance()
		music.stream = Definitions.BGM[bgmID]
		music.play()
		add_child(music)
		
		if getMusicPeakVolume() != Vector2(-200, -200):
			debugOverlay.add_var("music peak volume (left, right)", self, "getMusicPeakVolume", true)
		
func _debugSetup():
	debugOverlay.add_var("hero position (X, Y)", $Player, "position", false)
	debugOverlay.add_var("object count", self, "get_child_count", true)
	add_child(debugOverlay)
