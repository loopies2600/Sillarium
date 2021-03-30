extends Control

export (int) var backgroundID = 0
export (int) var musicID = 0

onready var buttons = [$Menu/Buttons/Play, $Menu/Buttons/Options, $Menu/Buttons/Exit]
onready var buildNumber = $Build

var targetPos := Vector2()

func _init():
	Objects.currentWorld = self
	
func _ready():
	Renderer.fade("out")
	randomize()
	buildNumber.text = "SILLARIUM BUILD " + str(randi() % 32768)
	Renderer.backgroundSetup(backgroundID)
	var _unused = Audio.connect("pump", self, "_onBeat")
	Audio.musicSetup(musicID)
	
func _onBeat(_beatNo):
	targetPos = Vector2(rand_range(-64, 64), rand_range(-64, 64))
	
func _process(delta):
	rect_position = lerp(rect_position, targetPos, 4 * delta)
