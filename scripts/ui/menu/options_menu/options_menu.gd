extends Control

export (int) var backgroundID = 0
export (int) var musicID = 0

onready var optionsText = $OptionsTitle
onready var exitButton = $Exit

func _ready():
	optionsText.bbcode_text = "[center][wave amp=32]" + tr("OM_TITLE")
	Renderer.fade("out")
	Renderer.backgroundSetup(backgroundID, {"dontShowCones" : false})
	Audio.musicSetup(musicID)
	_spawnButtons()
	
func _spawnButtons(section := "renderer"):
	var startingBID = 1
	
	for key in Settings._settings[section].keys():
		var val = Settings._configFile.get_value(section,key)
		
		var newButton = Button.new()
		newButton.set_script(preload("option_button.gd"))
		newButton.category = section
		newButton.key = key
		newButton.val = val
		newButton.font = exitButton.get_font("font")
		newButton.buttonID = startingBID
		newButton.add_to_group("Option")
		newButton.rect_position = Vector2(32 + (64 * startingBID), 32 + (64 * startingBID))
		
		add_child(newButton)
		startingBID += 1
		
func toggleButtons():
	for node in get_tree().get_nodes_in_group("Option"):
		if node is Button:
			if node.has_focus():
				node.release_focus()
				
			node.disabled = !node.disabled
		else:
			if node.visible:
				node.hide()
			else:
				node.show()
