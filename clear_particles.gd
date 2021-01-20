extends Particles2D

func _process(_delta):
	if not emitting:
		queue_free()
