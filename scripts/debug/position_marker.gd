extends Sprite

var fadeSpeed = 0.005

func _process(delta):
	modulate.a -= fadeSpeed
	
	if modulate.a < 0.0:
		queue_free()
