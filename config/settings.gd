extends Node

enum {LOAD_SUCCESS, LOAD_ERROR_COULDNT_OPEN}

const SAVE_PATH = "res://config/settings.cfg"

var _configFile = ConfigFile.new()

var _settings = {
	"Autogenerado por el juego.": { "author" : "aSillyTeam" },
	"general": {
		"debug_mode" : true
	},
	"controls":
		{
			"move_left": KEY_LEFT,
			"move_right": KEY_RIGHT,
			"jump": KEY_SPACE,
			"aim_up": KEY_UP,
			"aim_down": KEY_DOWN,
			"aim_left": KEY_LEFT,
			"aim_right": KEY_RIGHT,
			"shoot": KEY_SHIFT,
			"dash": KEY_SHIFT,
			"input_lock": KEY_C,
			"debug_screen": KEY_L
	},
	"audio": {
		"mute_audio": true
	},
	"renderer": {
		"display_backgrounds": true
	}
}

func _ready():
	loadSettings()
	bindKeys()
	
func bindKeys():
	for key in _configFile.get_section_keys("controls"):
		var value = _configFile.get_value("controls", key)
		
		var actionList = InputMap.get_action_list(key)
		
		if !actionList.empty():
			InputMap.action_erase_event(key, actionList[0])
			
		var newKey = InputEventKey.new()
		newKey.set_scancode(value)
		InputMap.action_add_event(key, newKey)
		
func saveSettings():
	for section in _settings.keys():
		for key in _settings[section].keys():
			# The ConfigFile object (_config_file is a ConfigFile) has all the methods you need to load, save, set and read values
			_configFile.set_value(section, key, _settings[section][key])
	
	_configFile.save(SAVE_PATH)
	
func loadSettings():
	var error = _configFile.load(SAVE_PATH)
	if error != OK:
		print("Error loading the settings. Error code: %s" % error)
		return LOAD_ERROR_COULDNT_OPEN
	
	print("Settings Loaded. File: %s" % SAVE_PATH)
	for section in _settings.keys():
		for key in _settings[section].keys():
			var val = _configFile.get_value(section,key)
			_settings[section][key] = val
			print("%s: %s" % [key, val])
	return LOAD_SUCCESS
	
func getSetting(category, key):
	return _settings[category][key]
	
func setSetting(category, key, value):
	_settings[category][key] = value
