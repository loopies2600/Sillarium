extends Node

onready var backgrounds = Settings.getSetting("renderer", "display_backgrounds")

var transition
var currentBackground

func spawnTrail(fds, tex, pos, rot, scl, z = 0):
	var newTrail = Objects.getObj(7)
	get_tree().get_root().add_child(newTrail)
	newTrail.fadeSpeed = fds
	newTrail.texture = tex
	newTrail.global_position = pos
	newTrail.global_rotation = rot
	newTrail.global_scale = scl
	newTrail.z_index = z
	
func fade(mode = "in", mask = preload("res://sprites/debug/radius.png")):
	if transition == null:
		var newFade = Objects.getObj(20)
		transition = newFade
		newFade.mode = mode
		newFade.mask = mask
		get_tree().get_root().call_deferred("add_child", newFade)
	
func backgroundSetup(bgID):
	if backgrounds:
		if (bgID != null):
			var backgroundToLoad = load(Globals.LoadJSON("res://data/json/backgrounds.json", bgID)["file"])
			
			if currentBackground == null:
				var background = backgroundToLoad
				currentBackground = background.instance()
				add_child(currentBackground)
			else:
				currentBackground.queue_free()
				
			if currentBackground != backgroundToLoad:
				currentBackground.queue_free()
				var background = backgroundToLoad
				currentBackground = background.instance()
				add_child(currentBackground)
		
