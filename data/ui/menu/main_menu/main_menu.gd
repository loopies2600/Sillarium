extends Control

export (int) var ID = 0

onready var buttons = [$Menu/Buttons/Play, $Menu/Buttons/Settings, $Menu/Buttons/SoundTest, $Menu/Buttons/Exit]
onready var buildNumber = $Build

func _ready():
	randomize()
	buildNumber.text = "SILLARIUM BUILD " + str(randi() % 32768)
	Globals.backgroundSetup(ID)
	Globals.musicSetup(ID)
	Globals.fade("out")
	buttons[0].grab_focus()
