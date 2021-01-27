extends Control

export (int) var backgroundID = 0

onready var buttons = [$Menu/Buttons/Play, $Menu/Buttons/Settings, $Menu/Buttons/SoundTest, $Menu/Buttons/Exit]
onready var buildNumber = $Build

func _ready():
	_setBG(backgroundID)
	randomize()
	buildNumber.text = "SILLARIUM BUILD " + str(randi() % 32768)
	Globals.fade("out")
	buttons[0].grab_focus()
	
func _setBG(bgID):
	var background = load(Globals.LoadJSON("res://data/json/backgrounds.json", bgID)["file"])
	var newBackground = background.instance()
	add_child(newBackground)
