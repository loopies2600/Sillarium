extends Node

func spawn(id, pos = Vector2(), vel = Vector2()):
	var objName = Globals.LoadJSON("res://data/json/objects.json", id)["name"]
	var obj = load(Globals.LoadJSON("res://data/json/objects.json", id)["file"])
	
	var newObj = obj.instance()
	newObj.velocity = vel
	newObj.global_position = pos
	get_tree().get_root().add_child(newObj)
	
func getObj(id):
	var obj = load(Globals.LoadJSON("res://data/json/objects.json", id)["file"])
	
	return obj.instance()
	
func spawnTrail(fds, tex, pos, rot, scl, z = 0):
	var newTrail = getObj(7)
	get_tree().get_root().add_child(newTrail)
	newTrail.fadeSpeed = fds
	newTrail.texture = tex
	newTrail.global_position = pos
	newTrail.global_rotation = rot
	newTrail.global_scale = scl
	newTrail.z_index = z
