extends Node

onready var musicPlayer = preload("res://streams/MusicPlayer.tscn")
onready var Definitions = preload("res://scenes/Definitions.gd").new()
export (int) var backgroundID
export (int) var musicID

func _ready():
	backgroundSetup(backgroundID)
	musicSetup(musicID)
	
func backgroundSetup(bgID):
	if (bgID != null):
		var background = Definitions.BG[bgID].instance()
		add_child(background)
	
func musicSetup(bgmID):
	if (bgmID != null):
		var music = musicPlayer.instance()
		music.stream = Definitions.BGM[bgmID]
		music.play()
		add_child(music)
