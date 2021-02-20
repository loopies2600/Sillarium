""" ESTE ES EL GRANDEEEEEEEEEEEEEEEEEEEEEEEEE 
	este singleton se encarga meramente a leer el archivo de configuración.
	pero creeme, es MUY complejo... """

extends Node

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
			"move_left": KEY_A,
			"move_right": KEY_D,
			"jump": KEY_W,
			"aim_up": KEY_UP,
			"aim_down": KEY_DOWN,
			"aim_left": KEY_LEFT,
			"aim_right": KEY_RIGHT,
			"shoot": KEY_SHIFT,
			"dash": KEY_SHIFT,
			"input_hold": KEY_C,
			"toggle_debug": KEY_L,
			"interact": KEY_Z,
			"pause": KEY_P
	},
	"audio": {
		"mute_audio": false
	},
	"renderer": {
		"camera_effects": true,
		"display_backgrounds": true
	}
}

func _ready():
	# por ahora, en _ready() vamos a tanto guardar como cargar la configuración, así que ni intentes editar el archivo porque lo vamos a sobreescribir.
	saveSettings()
	loadSettings()
	bindKeys()
	
func bindKeys():
	# está esta complicadita, primero debe leer cada clave que haya en controles.
	
	for key in _configFile.get_section_keys("controls"):
		# luego guarda un valor en value, y así en bucle
		var value = _configFile.get_value("controls", key)
		
		# tiene que encontrar la lista con el nombre de esa acción.
		var actionList = InputMap.get_action_list(key)
		
		# si la lista no está vacia, va a borrar los eventos---
		if !actionList.empty():
			InputMap.action_erase_event(key, actionList[0])
			
		# para luego reemplazarlos con el evento que está escrito en el archivo de configuración.
		var newKey = InputEventKey.new()
		newKey.set_scancode(value)
		InputMap.action_add_event(key, newKey)
		
func saveSettings():
	# primero tiene que ir en bucle por cada sección en el diccionario de las opciones, así las va guardando en el archivo CFG.
	for section in _settings.keys():
		for key in _settings[section].keys():
			# si queres conseguir, editar o leer valores, ConfigFile tiene todas las funciones necesarias.
			_configFile.set_value(section, key, _settings[section][key])
	
	# cuando está todo hecho, guardamos el archivo.
	_configFile.save(SAVE_PATH)
	
func loadSettings():
	# se nota que esto es más complejo. tiene que leer la configuración desde SAVE_PATH, que es el hipotetico lugar donde se guarda nuestra configuraciṕóm.
	var error = _configFile.load(SAVE_PATH)
	
	# si no podemos leer la configuración, es obvio que el juego va a crashear, pero en caso de que no lo haga mandamos este error al motor.
	if error != OK:
		print("Error loading the settings. Error code: %s" % error)
		return LOAD_ERROR_COULDNT_OPEN
	
	# si pudimos leerla le avisamos al editor y empezamos a analizarla.
	print("Settings Loaded. File: %s" % SAVE_PATH)
	
	for section in _settings.keys():
		# como con los controles o como cuando guardamos, tenemos que leer cada sección, una por una, por ello hacemos varios bucles.
		for key in _settings[section].keys():
			var val = _configFile.get_value(section,key)
			_settings[section][key] = val
			print("%s: %s" % [key, val])
			
	# y entonces le avisamos que es un positivo, además de imprimir cada clave en la consola.
	return LOAD_SUCCESS
	
func getSetting(category, key):
	# está función es para agarrar algún valor de alguna clave de configuración.
	return _settings[category][key]
	
func setSetting(category, key, value):
	# y está para cambiar algún valor.
	_settings[category][key] = value
