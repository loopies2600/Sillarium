extends Control

export (int) var backgroundID = 0
export (int) var musicID = 0

onready var buttons = [$Menu/Buttons/Play, $Menu/Buttons/Settings, $Menu/Buttons/SoundTest, $Menu/Buttons/Exit]
onready var buildNumber = $Build

func _init():
	TranslationServer.set_locale("es")
	Objects.currentWorld = self
	
func _ready():
	Renderer.fade("out")
	randomize()
	buildNumber.text = "SILLARIUM BUILD " + str(randi() % 32768)
	Renderer.backgroundSetup(backgroundID)
	Audio.musicSetup(musicID)
	Renderer.fade("out")
	buttons[0].grab_focus()
