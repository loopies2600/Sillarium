extends Sprite

export (float) var eyeRadius = 8

onready var player = Globals.get("player")
onready var target = player
onready var center = position

func _process(_delta):
	var lookDirection = (target.global_position - global_position).normalized()
	position = center + lookDirection * eyeRadius
	
