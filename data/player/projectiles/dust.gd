extends AnimatedSprite

var substract = 0.1

func _ready():
	play()
	connect("animation_finished", self, "_animEnd")
	connect("frame_changed", self, "_frameChange")
	
func _frameChange():
	modulate.a -= substract
	scale += Vector2(substract, substract)
	
func _animEnd():
	queue_free()
