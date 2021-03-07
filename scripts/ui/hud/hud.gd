extends Control

onready var bg = $Background

func _process(delta):
	bg.flip_v = !bg.flip_v
