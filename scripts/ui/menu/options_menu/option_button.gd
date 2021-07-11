extends "res://scripts/ui/menu/button.gd"

enum {SWITCH, INPUT, VALUE}

var type = VALUE
var category
var key
var val
var font

func _ready():
	var _unused = Settings.connect("settings_changed", self, "updateText")
	theme = preload("res://themes/main_theme.tres")
	updateText()
	
	yield(get_tree().create_timer(0.1 * buttonID), "timeout")
	moveTowards = true
	
func _onCategorySwitch(isOpen):
	if !isOpen:
		yield(get_tree().create_timer(0.05 * buttonID), "timeout")
		targetPos = Vector2(-720, rect_position.y)
		yield(get_tree().create_timer(1), "timeout")
		queue_free()
		
func onMouseEnter():
	if !disabled:
		Audio.playSound(8)
		selectedButton = buttonID
		var buttonDescTR = "OM_BT" + str(selectedButton)
		#get_tree().get_current_scene().buttonDesc.text = tr(buttonDescTR).to_upper()
	
func onMouseExit():
	selectedButton = null
	var buttonDescTR = "OM_BTNULL"
	#get_tree().get_current_scene().buttonDesc.text = tr(buttonDescTR).to_upper()
	
func buttonPress():
	match type:
		SWITCH:
			val = !val
			
			if val:
				Audio.playSound(6)
			else:
				Audio.playSound(7)
				
			Settings.setSetting(category, key, val)
			Settings.saveSettings()
			
			if key == "direct_rendering":
				Renderer.toggleDirectRendering()
			if key == "display_backgrounds":
				Renderer.backgroundSetup(get_tree().get_current_scene().backgroundID, {"dontShowCones" : false})
			if key == "fullscreen":
				Renderer.toggleFS()
			if key == "mute_audio":
				Audio.musicSetup(get_tree().get_current_scene().musicID)
			if key == "vsync":
				Renderer.toggleVSync()
				
		INPUT:
			Audio.playSound(6)
			
			get_tree().get_current_scene().toggleButtons()
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
