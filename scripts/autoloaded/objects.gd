""" este singleton se encarga de manejar cosas relacionadas al spawneo de objetos y demas
	editar con MUCHISIMA precaución. """

extends Node

const OBJ = "res://data/database/objects/"
const PICKUP = "res://data/database/pickups/"

var nodes := []
var previousScene

func _ready():
	Globals.connect("scene_changed", self, "registerEveryNode")
	
func spawnPlayer(charID, pos, pSlot := "player"):
	var currentChar = load(OBJ + "10.tres").scenes[charID].instance()
	
	if Globals.get(pSlot) == null:
		get_tree().get_root().call_deferred("add_child", currentChar)
		Globals.set(pSlot, currentChar)
		
	Globals.get(pSlot).charID = charID
	Globals.get(pSlot).global_position = pos
	Globals.get(pSlot).slot = pSlot
	
	match pSlot:
		"player":
			Globals.get(pSlot).inputSuffix = ""
		"playerTwo":
			Globals.get(pSlot).inputSuffix = "_to"
			Globals.get(pSlot).camera.queue_free()
	
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
	
func spawn(id, cVars = {}, subScene := 0):
	var obj = load(OBJ + "%s.tres" % id).scenes[subScene]
	
	var newObj = obj.instance()
	
	setupCustomVars(newObj, cVars)
	get_tree().get_current_scene().add_child(newObj)
	
	registerEveryNode()
	return newObj
	
func getWeapon(id, curPlayer, z, _ammo = 0):
	var resource = load(PICKUP + "%s.tres" % id)
	var wpsType = resource.resource
	var wps = resource.scene
	
	var weapon = wps.instance()
	weapon.z_index = z
	weapon.currentPlayer = curPlayer
	weapon.type = wpsType
	return weapon
	
func getObj(id, subScene := 0):
	return load(OBJ + "%s.tres" % id).scenes[subScene].instance()
	
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
