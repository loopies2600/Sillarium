extends Sprite

var t = 0
var increment = 12
var amplitude = 8

onready var yy = position.y
onready var xx = position.x

func _process(_delta):
	t = (t + increment) % 360
	var shift = amplitude * sin(deg2rad(t))
	
	position.y = yy + shift
	modulate.a = 1 + shift * 0.125
	
func _unhandled_input(_event):
	queue_free()
