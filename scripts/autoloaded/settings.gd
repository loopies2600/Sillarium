""" ESTE ES EL GRANDEEEEEEEEEEEEEEEEEEEEEEEEE 
	este singleton se encarga meramente a leer el archivo de configuración.
	pero creeme, es MUY complejo... """

extends Node

signal settings_changed
# dependiendo de si se haya podido leer el archivo o no, va a devolver alguno de estos dos. es muy obvio lo que hacen.
enum {LOAD_SUCCESS, LOAD_ERROR_COULDNT_OPEN}

# donde deberiamos guardar el archivo de configuración, no sé, pero no donde se te antoje.
const SAVE_PATH = "user://sillarium.cfg"

# ConfigFile es un objeto de Godot que se especializa en manejar textos de configuración, que conveniente, no?
var _configFile = ConfigFile.new()

# este diccionario contiene todos los parametros que usamos y leemos, muy importante mantener el formato si queres agregar alguno.
var _settings = {
	"general": {
		"debug_mode" : true
	},
	"controls":
		{
			"take_screenshot": KEY_F12,
			"toggle_debug": KEY_L,
			"toggle_fullscreen": KEY_F11,
			"pause": KEY_P
	},
	"player_one":
		{
			"move_left": KEY_LEFT,
			"move_right": KEY_RIGHT,
			"jump": KEY_Z,
			"aim_up": KEY_UP,
			"aim_down": KEY_DOWN,
			"aim_left": KEY_LEFT,
			"aim_right": KEY_RIGHT,
			"shoot": KEY_X,
			"dash": KEY_S,
			"input_hold": KEY_A,
			"interact": KEY_C
	},
	"player_two":
		{
			"move_left_to": KEY_KP_4,
			"move_right_to": KEY_KP_6,
			"jump_to": KEY_K,
			"aim_up_to": KEY_KP_8,
			"aim_down_to": KEY_KP_2,
			"aim_left_to": KEY_KP_4,
			"aim_right_to": KEY_KP_6,
			"shoot_to": KEY_U,
			"dash_to": KEY_O,
			"input_hold_to": KEY_I,
			"interact_to": KEY_J
	},
	"audio": {
		"mute_audio": false
	},
	"renderer": {
		"camera_effects": true,
		"display_backgrounds": true,
		"display_weather": true,
		"fullscreen": false,
		"freeze_frame": true,
		"vsync" : false
	},
	"dont-autogenerate-buttons": {
		"lang": "en",
		"master_volume": 1.0,
		"music_volume": 1.0,
		"sound_volume": 1.0,
		"accent_color_0": Color.orange,
		"accent_color_1": Color.red,
		"accent_color_2": Color.blue
	}
}

func _ready():
	saveSettings()
	var didLoad = loadSettings()
	
	if didLoad != OK:
		print("Settings file doesn't exist, creating one...")
		saveSettings()
		loadSettings()
	
func bindKeys(clear := false):
	if clear:
		for cat in ["player_one", "player_two"]:
			for key in _configFile.get_section_keys(cat):
				# luego guarda un valor en value, y así en bucle
				var value = _configFile.get_value(cat, key)
				
				# tiene que encontrar la lista con el nombre de esa acción.
				var actionList = InputMap.get_action_list(key)
				
				# si la lista no está vacia, va a borrar los eventos---
				if !actionList.empty():
					InputMap.action_erase_event(key, actionList[0])
	else:
		for cat in ["controls", "player_one", "player_two"]:
			for key in _configFile.get_section_keys(cat):
				# luego guarda un valor en value, y así en bucle
				var value = _configFile.get_value(cat, key)
				
				# tiene que encontrar la lista con el nombre de esa acción.
				var actionList = InputMap.get_action_list(key)
				
				# si la lista no está vacia, va a borrar los eventos---
				if !actionList.empty():
					InputMap.action_erase_event(key, actionList[0])
				
				# para luego reemplazarlos con el evento que está escrito en el archivo de configuración.
				var newKey = InputEventKey.new()
				newKey.set_scancode(value)
				InputMap.action_add_event(key, newKey)
			
	emit_signal("settings_changed")
		
func saveSettings():
	# primero tiene que ir en bucle por cada sección en el diccionario de las opciones, así las va guardando en el archivo CFG.
	for section in _settings.keys():
		for key in _settings[section].keys():
			# si queres conseguir, editar o leer valores, ConfigFile tiene todas las funciones necesarias.
			_configFile.set_value(section, key, _settings[section][key])
	
	_configFile.save(SAVE_PATH)
	bindKeys()
	emit_signal("settings_changed")
	
func loadSettings():
	# se nota que esto es más complejo. tiene que leer la configuración desde SAVE_PATH, que es el hipotetico lugar donde se guarda nuestra configuraciṕóm.
	var error = _configFile.load(SAVE_PATH)
	
	# si no podemos leer la configuración, es obvio que el juego va a crashear, pero en caso de que no lo haga mandamos este error al motor.
	if error != OK:
		print(tr("CFG_LOAD_ERROR") % error)
		return LOAD_ERROR_COULDNT_OPEN
	
	# si pudimos leerla le avisamos al editor y empezamos a analizarla.
	print(tr("CFG_LOAD_SUCCESS") % SAVE_PATH)
	
	for section in _settings.keys():
		# como con los controles o como cuando guardamos, tenemos que leer cada sección, una por una, por ello hacemos varios bucles.
		for key in _settings[section].keys():
			var val = _configFile.get_value(section,key)
			_settings[section][key] = val
			
	# y entonces le avisamos que es un positivo, además de imprimir cada clave en la consola.
	bindKeys()
	emit_signal("settings_changed")
	return LOAD_SUCCESS
	
func getSetting(category, key):
	# está función es para agarrar algún valor de alguna clave de configuración.
	return _settings[category][key]
	
func setSetting(category, key, value):
	# y está para cambiar algún valor.
	_settings[category][key] = value
	emit_signal("settings_changed")
