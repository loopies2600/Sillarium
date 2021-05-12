extends CPUParticles2D

var particles = Settings.getSetting("renderer", "particles")

func _init():
	if !particles:
		queue_free()
		
func _process(_delta):
	if not emitting:
		queue_free()
