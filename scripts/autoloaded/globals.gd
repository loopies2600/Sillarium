""" este fue el primer singleton que hicimos, guarda funciones muy utiles. """

extends Node

# se usan globalmente, bueno, como todo singleton.
const SCENE = "res://data/json/scenes.json"

const UP = Vector2.UP
const MAX_FLOOR_ANGLE = 60
const UNIT_SIZE = 64
const CELL_SIZE = Vector2(64, 32)
const GRAVITY = 980

# se usa para registrar los jugadores.
var player
var playerTwo

# aca registramos la interfaz debug, y checkeamos si deberiamos activarlo.
onready var debugMenuOpen := false
onready var debugOverlay = Objects.getObj(18)
onready var debug = Settings.getSetting("general", "debug_mode")

func _ready():
	var _unused = Settings.connect("settings_changed", self, "_onSetChanges")
	
	if debug:
		add_child(debugOverlay)
		
func _onSetChanges():
	debug = Settings.getSetting("general", "debug_mode")
	debugMenuOpen = false
	
func quadBezier(p0: Vector2, p1: Vector2, p2: Vector2, time: float):
	# para interpolar movimientos usando el algoritmo del bezier cuadrado
	var q0 = p0.linear_interpolate(p1, time)
	var q1 = p1.linear_interpolate(p2, time)
	
	var r = q0.linear_interpolate(q1, time)
	return r
	
func cubicBezier(p0: Vector2, p1: Vector2, p2: Vector2, p3: Vector2, time: float):
	# para interpolar movimientos usando el algoritmo del bezier cubico
	var q0 = p0.linear_interpolate(p1, time)
	var q1 = p1.linear_interpolate(p2, time)
	var q2 = p2.linear_interpolate(p3, time)
	
	var r0 = q0.linear_interpolate(q1, time)
	var r1 = q1.linear_interpolate(q2, time)
	
	var r = r0.linear_interpolate(r1, time)
	return r
	
func LoadScene(sceneID : int, cVars := {}):
	var curScene
	
	for i in range(getJSONSize(SCENE)):
		for c in get_tree().get_root().get_children():
			if c.filename == LoadJSON(SCENE, i, "file"):
				curScene = c
				
	var curSceneName = curScene.filename
	var newSceneName = LoadJSON(SCENE, sceneID, "file")
	
	if newSceneName == curSceneName:
		return true
	else:
		get_tree().get_root().remove_child(curScene)
		curScene.call_deferred("free")
		
		var newScene = load(newSceneName).instance()
		Objects.setupCustomVars(newScene, cVars)
		get_tree().get_root().call_deferred("add_child", newScene)
		get_tree().call_deferred("set_current_scene", newScene)
		return false
	
func LoadJSON(file : String, index : int, property : String):
	# este es el grande, con esta función podemos leer archivos JSON :).
	var jsonFile = File.new()
	jsonFile.open(file, File.READ)
	
	var jsonString = jsonFile.get_as_text()
	var parsed : Dictionary = parse_json(jsonString)
	jsonFile.close()
	
	return parsed[str(index)][property]
	
func getJSONEntryName(jsonFile, id):
	var tempName = Globals.LoadJSON(jsonFile, id, "name")
	
	return tempName
	
func getJSONSize(file : String):
	var jsonFile = File.new()
	jsonFile.open(file, File.READ)
	
	var jsonString = jsonFile.get_as_text()
	var parsed : Dictionary = parse_json(jsonString)
	jsonFile.close()
	
	return parsed.size()
