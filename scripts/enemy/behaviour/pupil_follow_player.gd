extends Sprite

export (float) var eyeRadius = 8

onready var center = position
onready var target = Globals.player

func _process(_delta):
	if target:
		var lookDirection = (target.global_position - global_position).normalized()
		position = center + lookDirection * eyeRadius
	
