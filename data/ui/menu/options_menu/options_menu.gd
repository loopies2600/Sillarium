extends Control

export (int) var backgroundID = 0
export (int) var musicID = 0

onready var optionsText = $OptionsTitle
onready var items = $Items
onready var exitButton = $Exit

var multiplier = 0.1

func _init():
	Objects.currentWorld = self
	
func _ready():
	Renderer.fade("out")
	exitButton.grab_focus()
	Renderer.backgroundSetup(backgroundID)
	Audio.musicSetup(musicID)
	_spawnButtons()
	
func _spawnButtons():
	for section in Settings._settings.keys():
		for key in Settings._settings[section].keys():
			var val = Settings._configFile.get_value(section,key)
			var newButton = Button.new()
			
			newButton.set_script(preload("option_button.gd"))
			newButton.category = section
			newButton.key = key
			newButton.val = val
			newButton.font = optionsText.get_font("normal_font")
			newButton.multiplier = multiplier
			multiplier -= 0.005
			
			items.add_child(newButton)
