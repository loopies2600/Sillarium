""" este singleton se encarga de manejar cosas relacionadas al spawneo de objetos y demas
	editar con MUCHISIMA precaución. """

extends Node

# world es la manera de la cual le decimo a las escenas que contienen niveles, y en esta variable registramos dichas escenas.
var currentWorld

func playerInit(charID, pos):
	var characters := [preload("res://data/player/player.tscn")]
	var currentChar = characters[charID].instance()
	
	if Globals.player == null:
		get_tree().get_root().add_child(currentChar)
		Globals.player = currentChar
		
	Globals.player.global_position = pos
	
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
	var objName = Globals.LoadJSON("res://data/json/objects.json", id)["name"]
	var obj = load(Globals.LoadJSON("res://data/json/objects.json", id)["file"])
	
	var newObj = obj.instance()
	if newObj is Node2D: newObj.global_position = pos
	currentWorld.add_child(newObj)
	
func getWeapon(id, pos, z, ammo = 0):
	# este es muy parecido al que spawnea objetos, pero tiene parametros extra especificos para las armas.
	var wpsType = load(Globals.LoadJSON("res://data/json/pickups.json", id)["file"])
	var wps = load(Globals.LoadJSON("res://data/json/pickups.json", id)["type"])
	
	var weapon = wps.instance()
	weapon.armsPos = pos
	weapon.z_index = z
	weapon.type = wpsType
	return weapon
	
func getObj(id):
	# este es como el que spawnea objetos, pero solo lee el archivo de objeto desde el JSON, el resto lo podes hacer vos mismo...
	var obj = load(Globals.LoadJSON("res://data/json/objects.json", id)["file"])
	
	return obj.instance()
