extends AnimatedSprite

var substract = 0.125

func _ready():
	play()
	connect("animation_finished", self, "_animEnd")
	connect("frame_changed", self, "_frameChange")
	
func _frameChange():
	scale += Vector2(substract, substract)
	modulate.a -= substract
	
func _animEnd():
	queue_free()
