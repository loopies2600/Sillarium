extends Node2D

signal level_ready
signal level_started(fromTimer)

export (int, FLAGS, "Background", "Music", "Weather", "Starting Level") var flags

export (int) var backgroundID
export (int) var musicID
export (int) var weatherID
export (int) var minsToBeat = 3

export (NodePath) var tiles
export (NodePath) var startPosition

onready var startPos = get_node(startPosition).position
onready var tileMap = get_node(tiles)

func _ready():
	Renderer.fade("out")
	
	Objects.spawnPlayer(0, startPos)
	
	if NumberStuff.isBitEnabled(flags, 0):
		Renderer.backgroundSetup(backgroundID)
	
	if NumberStuff.isBitEnabled(flags, 3):
		var startTimer = Objects.spawn(25)
		startTimer.connect("level_start", self, "start")
	else:
		start(false)
	
	yield(get_tree().create_timer(0.1), "timeout")
	
	for node in get_tree().get_nodes_in_group("LevelStateObserver"):
		var _unused = connect("level_ready", node, "_onLevelReady")
		_unused = connect("level_started", node, "_onLevelStart")
	
	Objects.spawn(22)
	emit_signal("level_ready")

func start(fromTimer : bool):
	if fromTimer:
		emit_signal("level_started")
	else:
		yield(get_tree().create_timer(0.5), "timeout")
		emit_signal("level_started")
		
	Objects.spawn(27, {"minsLeft" : minsToBeat})
	
	if NumberStuff.isBitEnabled(flags, 1):
		Audio.musicSetup(musicID)
