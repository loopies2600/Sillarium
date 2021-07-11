extends Control

signal category_switched(isOpen)

export (int) var backgroundID = 0
export (int) var musicID = 0

onready var notice = load("res://sprites/debug/itcantfitlol.png")

onready var anim = $Animator
onready var buttons = [$General, $Renderer, $Controls, $Audio]
onready var exitButton = $Exit
onready var optionsText = $OptionsTitle

var categoryOpen := false setget _setCatOpen
var startingBID = 1
var sectionScrolls := false

func _ready():
	var _unused = connect("category_switched", exitButton, "_onCategorySwitch")
	
	optionsText.bbcode_text = "[center][wave amp=32]" + tr("OM_TITLE")
	Renderer.fade("out")
	Renderer.backgroundSetup(backgroundID, {"dontShowCones" : false})
	Audio.musicSetup(musicID)
	
	for bt in buttons:
		_unused = bt.connect("pressed", self, "_on" + bt.name + "Pressed")
		
func _draw():
	if sectionScrolls:
		draw_texture(notice, Vector2(896, 128))
	
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
		sectionScrolls = false
		
	startingBID = 1
	update()
	
func _spawnButtons(section := "renderer"):
	if section == "controls":
		sectionScrolls = true
		for key in Settings._settings["player_one"].keys():
			_addButton("player_one", key, sectionScrolls)
			
	for key in Settings._settings[section].keys():
		_addButton(section, key, sectionScrolls)
		
func _addButton(sect, k, scrollable := false):
	var val = Settings._configFile.get_value(sect,k)
		
	var newButton = Button.new()
	newButton.set_script(preload("option_button.gd"))
	newButton.category = sect
	newButton.key = k
	newButton.val = val
	newButton.font = exitButton.get_font("font")
	newButton.buttonID = startingBID
	newButton.scrollable = scrollable
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
