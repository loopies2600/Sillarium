extends Control

export (int) var backgroundID = 0
export (int) var musicID = 0

onready var optionsText = $OptionsTitle
onready var categories = [$Items/Renderer/General, $Items/Controls, $Items/Controls/WayTooBig/P1Controls, $Items/Controls/WayTooBig/P2Controls, $Items/Renderer, $Items/Audio]
onready var langButton = $Items/Renderer/General/LanguageButton
onready var exitButton = $Exit
onready var buttonDesc = $InfoContainer/SelectionInfo/Description

var multiplier = 0.1

func _init():
	Objects.currentWorld = self
	
func _ready():
	optionsText.bbcode_text = "[wave amp=32]" + tr("OM_TITLE")
	Renderer.fade("out")
	Renderer.backgroundSetup(backgroundID, {"dontShowCones" : false})
	Audio.musicSetup(musicID)
	langButton.connect("pressed", self, "_langButtonPress")
	langButton.connect("mouse_entered", self, "_langMouseEnter")
	langButton.connect("mouse_exited", self, "_langMouseExit")
	_spawnButtons()
	
func _spawnButtons():
	var startingBID = 1
	
	for section in Settings._settings.keys():
		for key in Settings._settings[section].keys():
			var val = Settings._configFile.get_value(section,key)
			
			var newButton = Button.new()
			newButton.set_script(preload("option_button.gd"))
			newButton.category = section
			newButton.key = key
			newButton.val = val
			newButton.font = langButton.get_font("font")
			newButton.buttonID = startingBID
			
			match section:
				"general":
					categories[0].add_child(newButton)
				"controls":
					categories[1].add_child(newButton)
				"player_one":
					categories[2].add_child(newButton)
				"player_two":
					categories[3].add_child(newButton)
				"renderer":
					categories[4].add_child(newButton)
				"audio":
					categories[5].add_child(newButton)
					
			startingBID += 1
	
func _langButtonPress():
	Audio.playSound(6)
	
	Objects.previousWorld = filename
	Renderer.fade("in")
	Renderer.transition.connect("fade_finished", self, "_fadeEnd")
	
func _langMouseEnter():
	Audio.playSound(8)
	var buttonDescTR = "OM_BT0"
	Objects.currentWorld.buttonDesc.text = tr(buttonDescTR).to_upper()
	
func _langMouseExit():
	var buttonDescTR = "OM_BTNULL"
	Objects.currentWorld.buttonDesc.text = tr(buttonDescTR).to_upper()
	
func _fadeEnd(_mode):
	Globals.LoadScene(7)
		
func toggleButtons(category):
	for child in categories[category].get_children():
		if child is Button:
			child.disabled = !child.disabled
			
		for c in child.get_children():
			if c is Button:
				c.disabled = !c.disabled
				
			for oc in c.get_children():
				if oc is Button:
					oc.disabled = !oc.disabled
