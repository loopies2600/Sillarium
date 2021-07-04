extends Control

signal category_switched(isOpen)

export (int) var backgroundID = 0
export (int) var musicID = 0

onready var anim = $Animator
onready var buttons = [$General, $Renderer, $Controls, $Audio]
onready var exitButton = $Exit
onready var optionsText = $OptionsTitle

var categoryOpen := false setget _setCatOpen

func _ready():
	var _unused = connect("category_switched", exitButton, "_onCategorySwitch")
	
	optionsText.bbcode_text = "[center][wave amp=32]" + tr("OM_TITLE")
	Renderer.fade("out")
	Renderer.backgroundSetup(backgroundID, {"dontShowCones" : false})
	Audio.musicSetup(musicID)
	
	for bt in buttons:
		_unused = bt.connect("pressed", self, "_on" + bt.name + "Pressed")
		
func _onGeneralPressed():
	_doButtonStuff("General")
	
func _onRendererPressed():
	_doButtonStuff("Renderer")
	
func _onControlsPressed():
	_doButtonStuff("Controls")
	
func _onAudioPressed():
	_doButtonStuff("Audio")
	
func _doButtonStuff(category : String):
	_spawnButtons(category.to_lower())
	self.categoryOpen = true
	
func _setCatOpen(booly : bool):
	categoryOpen = booly
	emit_signal("category_switched", categoryOpen)
	
	if categoryOpen:
		anim.play("Out")
	else:
		anim.play("In")
	
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
		newButton.rect_position = Vector2(-1280, 32 + (64 * startingBID))
		newButton.targetPos = Vector2(32 + (32 * startingBID), 32 + (64 * startingBID))
		var _unused = connect("category_switched", newButton, "_onCategorySwitch")
		
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
