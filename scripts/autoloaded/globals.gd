""" este fue el primer singleton que hicimos, guarda funciones muy utiles. """

extends Node

signal scene_changed(newScene)
# se usan globalmente, bueno, como todo singleton.
const SCENE = "res://data/database/scenes/"

const UP = Vector2.UP
const MAX_FLOOR_ANGLE = 60
const UNIT_SIZE = 64
const CELL_SIZE = Vector2(64, 32)
const GRAVITY = 9.80665 * 2

# se usa para registrar los jugadores.
var player
var playerTwo

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
	var curScene = get_tree().get_current_scene()
	var newScene = load(SCENE + "%s.tres" % sceneID).scenes[0].instance()
	print(newScene.filename)
	if newScene.filename == curScene.filename:
		return true
	else:
		get_tree().get_root().remove_child(curScene)
		curScene.call_deferred("free")
		
		newScene.connect("tree_entered", get_tree(), "set_current_scene", [newScene], CONNECT_ONESHOT)
		Objects.setupCustomVars(newScene, cVars)
		get_tree().get_root().call_deferred("add_child", newScene)
		
		emit_signal("scene_changed", newScene)
		return false
	
func LoadJSON(file : String, index : int, property : String):
	# este es el grande, con esta función podemos leer archivos JSON :).
	var jsonFile = File.new()
	jsonFile.open(file, File.READ)
	
	var jsonString = jsonFile.get_as_text()
	var parsed : Dictionary = parse_json(jsonString)
	jsonFile.close()
	
	return parsed[str(index)][property]
	
func getResourceName(path, id):
	return load(path + "%s.tres" % id).name
	
func getJSONSize(file : String):
	var jsonFile = File.new()
	jsonFile.open(file, File.READ)
	
	var jsonString = jsonFile.get_as_text()
	var parsed : Dictionary = parse_json(jsonString)
	jsonFile.close()
	
	return parsed.size()
