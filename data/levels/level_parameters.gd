extends Node2D

onready var musicPlayer = preload("res://streams/music_player.tscn")
onready var debugOverlay = preload("res://debug/debug_overlay.tscn").instance()

export (int) var backgroundID
export (int) var musicID

func _ready():
	Renderer.fade("out")
	Renderer.backgroundSetup(backgroundID)
	Audio.musicSetup(musicID)
	Globals.debugSetup()
