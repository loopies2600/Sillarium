extends CPUParticles2D

func _process(delta):
	gravity.x = int(rand_range(400, 600))
	gravity.y = int(rand_range(800, 1000))
