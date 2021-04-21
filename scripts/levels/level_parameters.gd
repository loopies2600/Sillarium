extends Node2D

signal level_initialized
signal level_started

export (NodePath) var startPosition
export (int) var backgroundID
export (int) var musicID
export (int) var weatherID

onready var startPos = get_node(startPosition).position

func _init():
	Objects.currentWorld = self
	var startTimer = Objects.spawn(25)
	startTimer.connect("level_start", self, "start")
	
func _ready():
	Audio.fade()
	
	Renderer.fade("out")
	Renderer.backgroundSetup(backgroundID)
	Renderer.weatherSetup(weatherID, {"grav" : Vector2(200, 800)})
	Objects.spawn(22)
	Objects.spawnPlayer(0, startPos)
	
	emit_signal("level_initialized")

func start():
	emit_signal("level_started")
	Audio.musicSetup(musicID)
