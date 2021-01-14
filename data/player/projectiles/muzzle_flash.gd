extends AnimatedSprite

var add = 0.4

func _ready():
	play()
	connect("animation_finished", self, "_animEnd")
	
func _process(delta):
	scale += Vector2(add, add)
	
func _animEnd():
	queue_free()
