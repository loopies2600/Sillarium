extends CanvasLayer

export (int) var backgroundID = 0
export (int) var musicID = 0

onready var anim = $Animator
onready var buttons = [$Menu/Buttons/Play, $Menu/Buttons/Options, $Menu/Buttons/Exit]
onready var buildNumber = $Build

var danced := false

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
	if danced:
		anim.play("DanceLeft")
	else:
		anim.play("DanceRight")
		
	danced = !danced
