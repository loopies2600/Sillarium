""" este singleton se encarga de manejar cosas relacionadas al spawneo de objetos y demas
	editar con MUCHISIMA precaución. """

extends Node

const OBJ = "res://data/database/objects.json"
const PICKUP = "res://data/database/pickups.json"

var nodes := []
var previousScene

func _ready():
	Globals.connect("scene_changed", self, "registerEveryNode")
	
func spawnPlayer(charID, pos, pSlot := "player"):
	var character = load(Globals.LoadJSON(OBJ, 10, str(charID)))
	var currentChar = character.instance()
	
	if Globals.get(pSlot) == null:
		get_tree().get_root().call_deferred("add_child", currentChar)
		Globals.set(pSlot, currentChar)
		
	Globals.get(pSlot).slot = pSlot
	
	match pSlot:
		"player":
			Globals.get(pSlot).inputSuffix = ""
		"playerTwo":
			Globals.get(pSlot).inputSuffix = "_to"
			Globals.get(pSlot).camera.queue_free()
			
	if OS.is_debug_build():
		Globals.debugOverlay.vars[1][1] = Globals.player
		Globals.debugOverlay.vars[3][1] = Globals.player
		Globals.debugOverlay.vars[2][1] = Globals.playerTwo
		Globals.debugOverlay.vars[4][1] = Globals.playerTwo
		
	Globals.get(pSlot).global_position = pos
	
	registerEveryNode()
	return Globals.get(pSlot)
	
func getClosestOrFurthest(caller : Object, groupName : String, getClosest := true) -> Object:
	var targetGroup = get_tree().get_nodes_in_group(groupName)
	var distanceAway = caller.global_transform.origin.distance_to(targetGroup[0].global_transform.origin)
	var returnObject = targetGroup[0]
	
	for object in targetGroup.size():
		var distance = caller.global_transform.origin.distance_to(targetGroup[object].global_transform.origin)
		
		if getClosest && distance < distanceAway:
			distanceAway = distance
			returnObject = targetGroup[object]
		elif !getClosest && distance > distanceAway:
			distanceAway = distance
			returnObject = targetGroup[object]
			
	return returnObject
	
func spawn(id, cVars = {}):
	# esta función primero lee el nombre y archivo del objeto desde el JSON, luego lo instancia. ah, no te olvides de pasarle una posición, si queres.
	var _objName = Globals.LoadJSON(OBJ, id, "name")
	var obj = load(Globals.LoadJSON(OBJ, id, "file"))
	
	var newObj = obj.instance()
	
	setupCustomVars(newObj, cVars)
	get_tree().get_current_scene().add_child(newObj)
	
	registerEveryNode()
	return newObj
	
func getWeapon(id, curPlayer, z, _ammo = 0):
	# este es muy parecido al que spawnea objetos, pero tiene parametros extra especificos para las armas.
	var wpsType = load(Globals.LoadJSON(PICKUP, id, "file"))
	var wps = load(Globals.LoadJSON(PICKUP, id, "type"))
	
	var weapon = wps.instance()
	weapon.z_index = z
	weapon.currentPlayer = curPlayer
	weapon.type = wpsType
	return weapon
	
func getObj(id):
	# este es como el que spawnea objetos, pero solo lee el archivo de objeto desde el JSON, el resto lo podes hacer vos mismo...
	var obj = load(Globals.LoadJSON(OBJ, id, "file"))
	
	return obj.instance()
	
func setupCustomVars(object, cVars := {}):
	if !cVars.empty():
		for variable in cVars:
			object.set(variable, cVars[variable])
	
func getAllNodes(root = get_tree().get_root()):
	for n in root.get_children():
		
		if n.get_child_count() > 0:
			nodes.append(n)
			getAllNodes(n)
			
		else:
			nodes.append(n)
	
func registerEveryNode(_newScene = "who cares???"):
	nodes.clear()
	
	getAllNodes()
