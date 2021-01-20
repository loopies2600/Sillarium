extends AnimatedSprite

var substract = 0.125

func _ready():
	play()
	var _unused = connect("animation_finished", self, "_animEnd")
	_unused = connect("frame_changed", self, "_frameChange")
	
func _frameChange():
	scale += Vector2(substract, substract)
	modulate.a -= substract
	
func _animEnd():
	queue_free()
