extends Sprite

onready var visibility = $VisibilityNotifier2D
var fadeSpeed = 0.1

func _ready():
	visibility.connect("screen_exited", self, "_kill")
	
func _process(_delta):
	modulate.a -= fadeSpeed
	modulate.b += fadeSpeed * 4
	
	if (modulate.a <= 0):
		_kill()
		
func _kill():
	queue_free()
