extends "res://scripts/ui/menu/button.gd"

enum {SWITCH, INPUT, VALUE}

var type = VALUE

var category
var key
var val

var font

func _ready():
	var _unused = Settings.connect("settings_changed", self, "updateText")
	theme = preload("res://sprites/ui/menu/main_theme.tres")
	updateText()
	
func onMouseEnter():
	Audio.playSound(8)
	selectedButton = buttonID
	var buttonDescTR = "OM_BT" + str(selectedButton)
	Objects.currentWorld.buttonDesc.text = tr(buttonDescTR).to_upper()
	
func onMouseExit():
	selectedButton = null
	var buttonDescTR = "OM_BTNULL"
	Objects.currentWorld.buttonDesc.text = tr(buttonDescTR).to_upper()
	
func buttonPress():
	Audio.playSound(6)
	
	match type:
		SWITCH:
			val = !val
			Settings.setSetting(category, key, val)
			Settings.saveSettings()
			
			if key == "display_backgrounds":
				Renderer.backgroundSetup(Objects.currentWorld.backgroundID, {"dontShowCones" : false})
			if key == "fullscreen":
				Renderer.toggleFS()
			if key == "mute_audio":
				Audio.musicSetup(Objects.currentWorld.musicID)
			if key == "vsync":
				Renderer.toggleVSync()
				
		INPUT:
			Objects.currentWorld.toggleButtons(1)
			var binder = preload("res://data/ui/menu/options_menu/key_binder.tscn")
			var newBinder = binder.instance()
			
			newBinder.inputCategory = category
			newBinder.daddyButton = self
			newBinder.control = str(key).to_upper()
			newBinder.key = OS.get_scancode_string(int(val)).to_upper()
			get_tree().get_root().add_child(newBinder)
			
	updateText()
	
func updateText():
	val = Settings._configFile.get_value(category,key)
	var confiText
	
	if str(val) == "True":
		type = SWITCH
		confiText = tr("YES")
		text = ("%s: %s" % [tr(str(key).to_upper()), confiText]).to_upper()
	elif str(val) == "False":
		type = SWITCH
		confiText = tr("NO")
		text = ("%s: %s" % [tr(str(key).to_upper()), confiText]).to_upper()
	elif str(val) is String:
		type = INPUT
		text = ("%s: %s" % [tr(str(key).to_upper()), OS.get_scancode_string(int(val))]).to_upper()
		
	text = text.replace("_", " ")
	add_font_override("font", font)
