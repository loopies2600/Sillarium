extends Node2D

onready var musicPlayer = preload("res://streams/music_player.tscn")
onready var debugOverlay = preload("res://debug/debug_overlay.tscn").instance()

export (NodePath) var startPosition
export (int) var backgroundID
export (int) var musicID

onready var startPos = get_node(startPosition).position

func _init():
	Objects.currentWorld = self
	
func _ready():
	var startTimer = Objects.spawn(25)
	startTimer.connect("level_start", self, "start")
	
	Audio.fade()
	Renderer.fade("out")
	Renderer.backgroundSetup(backgroundID)
	Objects.spawn(22)
	Objects.playerInit(0, startPos)
	
func start():
	Globals.player.canInput = true
	Audio.musicSetup(musicID)
