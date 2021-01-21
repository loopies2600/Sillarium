extends AnimatedSprite

var substract = 0.125
onready var visibility = $VisibilityNotifier2D

func _ready():
	play()
	var _unused = visibility.connect("screen_exited", self, "_kill")
	_unused = connect("animation_finished", self, "_kill")
	_unused = connect("frame_changed", self, "_frameChange")
	
func _frameChange():
	scale += Vector2(substract, substract)
	modulate.a -= substract
	
func _kill():
	queue_free()
