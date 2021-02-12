""" este fue el primer singleton que hicimos, guarda funciones muy utiles. """

extends Node

# se usa globalmente para las fisicas... para qué es el UNIT_SIZE???
const UP = Vector2.UP
const MAX_FLOOR_ANGLE = 60
const UNIT_SIZE = 128

# se usa para registrar el jugador y el arma actual.
var player
var weapon

# aca registramos la interfaz debug, y checkeamos si deberiamos activarlo.
onready var debugOverlay = Objects.getObj(18)
onready var debug = Settings.getSetting("general", "debug_mode")

func _init():
	# aca iniciamos la interfaz debug si el modo debug esta activado.
	if debug:
		debugOverlay.add_var("player position (X, Y)", player, "global_position", false)
		debugOverlay.add_var("object count", self, "get_child_count", true)
		add_child(debugOverlay)
	
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
	
func LoadScene(sceneName):
	# con esta función cargamos escenas desde ese JSON.
	var newScene = LoadJSON("res://data/json/scenes.json", sceneName)["file"]
	get_tree().change_scene(newScene)
	
func LoadJSON(file, index):
	# este es el grande, con esta función podemos leer archivos JSON :).
	var jsonFile = File.new()
	jsonFile.open(file, File.READ)
	
	var parsed = JSON.parse(jsonFile.get_as_text())
	jsonFile.close()
	
	return parsed.result[str(index)]
	
