extends Sprite

var fadeSpeed = 0.1

func _process(delta):
	modulate.a -= fadeSpeed
	modulate.b += fadeSpeed * 4
	
	if (modulate.a <= 0):
		queue_free()
