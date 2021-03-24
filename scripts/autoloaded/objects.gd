""" este singleton se encarga de manejar cosas relacionadas al spawneo de objetos y demas
	editar con MUCHISIMA precaución. """

extends Node

const OBJ = "res://data/json/objects.json"
const PICKUP = "res://data/json/pickups.json"

# world es la manera de la cual le decimo a las escenas que contienen niveles, y en esta variable registramos dichas escenas.
var currentWorld
var previousWorld

func spawnPlayer(charID, pos, respawning := false, pSlot := "player"):
	var characters := [preload("res://data/player/player.tscn")]
	var currentChar = characters[charID].instance()
	
	if Globals.get(pSlot) == null:
		get_tree().get_root().add_child(currentChar)
		Globals.set(pSlot, currentChar)
		
	Globals.get(pSlot).slot = pSlot
	
	match pSlot:
		"player":
			Globals.get(pSlot).inputSuffix = ""
		"playerTwo":
			Globals.get(pSlot).inputSuffix = "_to"
			
	Globals.get(pSlot).global_position = pos
	Globals.get(pSlot).connectSignals()
	
	if respawning:
		Globals.get(pSlot).emit_signal("player_respawned")
	
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
	
func spawn(id, pos = Vector2()):
	# esta función primero lee el nombre y archivo del objeto desde el JSON, luego lo instancia. ah, no te olvides de pasarle una posición, si queres.
	var _objName = Globals.LoadJSON(OBJ, id, "name")
	var obj = load(Globals.LoadJSON(OBJ, id, "file"))
	
	var newObj = obj.instance()
	if newObj is Node2D: newObj.global_position = pos
	currentWorld.add_child(newObj)
	
	return newObj
	
func getWeapon(id, pos, z, _ammo = 0):
	# este es muy parecido al que spawnea objetos, pero tiene parametros extra especificos para las armas.
	var wpsType = load(Globals.LoadJSON(PICKUP, id, "file"))
	var wps = load(Globals.LoadJSON(PICKUP, id, "type"))
	
	var weapon = wps.instance()
	weapon.armsPos = pos
	weapon.z_index = z
	weapon.type = wpsType
	return weapon
	
func getObj(id):
	# este es como el que spawnea objetos, pero solo lee el archivo de objeto desde el JSON, el resto lo podes hacer vos mismo...
	var obj = load(Globals.LoadJSON(OBJ, id, "file"))
	
	return obj.instance()
