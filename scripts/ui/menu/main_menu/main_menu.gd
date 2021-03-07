extends Control

export (int) var backgroundID = 0
export (int) var musicID = 0

onready var buttons = [$Menu/Buttons/Play, $Menu/Buttons/Options, $Menu/Buttons/SoundTest, $Menu/Buttons/Exit]
onready var buildNumber = $Build

func _init():
	Objects.currentWorld = self
	
func _ready():
	Renderer.fade("out")
	randomize()
	buildNumber.text = "SILLARIUM BUILD " + str(randi() % 32768)
	Renderer.backgroundSetup(backgroundID)
	Audio.musicSetup(musicID)
	buttons[0].grab_focus()
