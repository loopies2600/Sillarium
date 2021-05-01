extends CanvasLayer

signal level_start

func _ready():
	Audio.playSound(4)
	
func _timeout():
	emit_signal("level_start", true)
	queue_free()
