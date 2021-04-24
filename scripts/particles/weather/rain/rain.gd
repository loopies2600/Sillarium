extends CanvasLayer

onready var emitter = $RainEmitter
onready var mat = emitter.get_process_material()
var grav := Vector2(400, 800) setget _setGravity

func _ready():
	_setGravity(grav)
	
func _setGravity(neoGrav : Vector2):
	grav = neoGrav
	mat.gravity.x = grav.x
	mat.gravity.y = grav.y
	mat.angle = -rad2deg(grav.angle())
