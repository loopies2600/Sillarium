extends CanvasLayer

signal fade_finished

onready var mask = preload("res://sprites/debug/radius.png")
onready var rect = $ColorRect
onready var animator = $ColorRect/AnimationPlayer
var mode = "in"

func _ready():
	rect.material.set_shader_param("mask", mask)
	animator.play(mode)
	animator.connect("animation_finished", self, "_fadeEnd")
	
func _fadeEnd(anim_name):
	if anim_name == "in":
		emit_signal("fade_finished")
		
	queue_free()
	
