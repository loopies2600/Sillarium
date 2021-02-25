extends Control

export (int) var backgroundID = 0
export (int) var musicID = 0

onready var optionsText = $OptionsTitle
onready var categories = [$Items/Renderer/General, $Items/Controls, $Items/Renderer, $Items/Audio]
onready var langButton = $Items/Renderer/General/LanguageButton
onready var exitButton = $Exit

var multiplier = 0.1

func _init():
	Objects.currentWorld = self
	
func _ready():
	optionsText.bbcode_text = "[wave amp=64]" + tr("OM_TITLE")
	Renderer.fade("out")
	exitButton.grab_focus()
	Renderer.backgroundSetup(backgroundID)
	Audio.musicSetup(musicID)
	langButton.connect("pressed", self, "_langButtonPress")
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
			
			match section:
				"general":
					categories[0].add_child(newButton)
				"controls":
					categories[1].add_child(newButton)
				"renderer":
					categories[2].add_child(newButton)
				"audio":
					categories[3].add_child(newButton)
	
func _langButtonPress():
	Objects.previousWorld = name
	Renderer.fade("in")
	Renderer.transition.connect("fade_finished", self, "_fadeEnd")
	
func _fadeEnd():
	Globals.LoadScene("LanguageSelect")
		
func toggleButtons(category):
	for child in categories[category].get_children():
		if child is Button:
			child.disabled = !child.disabled
