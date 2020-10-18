extends Node2D

onready var musicPlayer = preload("res://streams/MusicPlayer.tscn")
onready var Definitions = preload("res://scenes/Definitions.gd").new()
export (int) var backgroundID
export (int) var musicID

func _ready():
	_backgroundSetup(backgroundID)
	_musicSetup(musicID)
	
func _backgroundSetup(bgID):
	if (bgID != null):
		var background = Definitions.BG[bgID].instance()
		add_child(background)
	
func _musicSetup(bgmID):
	if (bgmID != null):
		var music = musicPlayer.instance()
		music.stream = Definitions.BGM[bgmID]
		music.play()
		add_child(music)
