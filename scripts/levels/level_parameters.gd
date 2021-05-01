extends Node2D

signal level_ready
signal level_started

export (bool) var hasWeather = false
export (int) var backgroundID
export (int) var musicID
export (int) var weatherID

export (NodePath) var tiles
export (NodePath) var startPosition

onready var startPos = get_node(startPosition).position
onready var tileMap = get_node(tiles)

func _ready():
	Audio.fade()
	
	Renderer.fade("out")
	Renderer.backgroundSetup(backgroundID)
	
	if hasWeather:
		Renderer.weatherSetup(weatherID, {"grav" : Vector2(200, 800)})
		
	var startTimer = Objects.spawn(25)
	startTimer.connect("level_start", self, "start")
	Objects.spawn(22)
	Objects.spawnPlayer(0, startPos)
	
	yield(get_tree().create_timer(0.1), "timeout")
	
	for node in get_tree().get_nodes_in_group("LevelStateObserver"):
		var _unused = connect("level_ready", node, "_onLevelReady")
		_unused = connect("level_started", node, "_onLevelStart")
		
	emit_signal("level_ready")

func start():
	emit_signal("level_started")
	Audio.musicSetup(musicID)
