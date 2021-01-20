extends AnimatedSprite

var add = 0.4

func _ready():
	play()
	var _unused = connect("animation_finished", self, "_animEnd")
	
func _process(_delta):
	scale += Vector2(add, add)
	
func _animEnd():
	queue_free()
