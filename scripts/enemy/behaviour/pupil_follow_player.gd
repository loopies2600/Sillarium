extends Sprite

export (float) var eyeRadius = 8

onready var center = position

func _process(_delta):
	if Globals.player:
		var lookDirection = (Globals.player.global_position - global_position).normalized()
		position = center + lookDirection * eyeRadius
	
