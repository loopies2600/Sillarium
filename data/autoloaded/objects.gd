extends Node

func spawn(id, pos = Vector2()):
	var objName = Globals.LoadJSON("res://data/json/objects.json", id)["name"]
	var obj = load(Globals.LoadJSON("res://data/json/objects.json", id)["file"])
	
	var newObj = obj.instance()
	newObj.global_position = pos
	get_tree().get_root().add_child(newObj)
	
func getObj(id):
	var obj = load(Globals.LoadJSON("res://data/json/objects.json", id)["file"])
	
	return obj.instance()
