extends CanvasLayer

onready var emitter = $RainEmitter

var grav := Vector2(400, 800) setget _setGravity
var particles = Settings.getSetting("renderer", "particles")

func _init():
	if !particles:
		queue_free()
		
	_setGravity(grav)
	
func _setGravity(neoGrav : Vector2):
	grav = neoGrav
	emitter.gravity.x = grav.x
	emitter.gravity.y = grav.y
	emitter.angle = -rad2deg(grav.angle())
