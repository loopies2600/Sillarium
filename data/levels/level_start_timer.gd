extends CanvasLayer

signal level_start

func _timeout():
	emit_signal("level_start")
	queue_free()
