extends Node

var currentWorld

func spawn(id, pos = Vector2()):
	var objName = Globals.LoadJSON("res://data/json/objects.json", id)["name"]
	var obj = load(Globals.LoadJSON("res://data/json/objects.json", id)["file"])
	
	var newObj = obj.instance()
	newObj.global_position = pos
	get_tree().get_root().add_child(newObj)
	
func getWeapon(id, pos, z, ammo = 0):
	var wpsType = load(Globals.LoadJSON("res://data/json/pickups.json", id)["file"])
	var wps = load(Globals.LoadJSON("res://data/json/pickups.json", id)["type"])
	
	var weapon = wps.instance()
	weapon.armsPos = pos
	weapon.z_index = z
	weapon.type = wpsType
	return weapon
	
func getObj(id):
	var obj = load(Globals.LoadJSON("res://data/json/objects.json", id)["file"])
	
	return obj.instance()
