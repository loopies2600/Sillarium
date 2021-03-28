extends CanvasLayer

signal fade_started(m)
signal fade_finished(m)

onready var rect = $ColorRect
onready var animator = $ColorRect/AnimationPlayer

var mask
var mode = "in"

func _ready():
	emit_signal("fade_started", mode)
	rect.material.set_shader_param("mask", mask)
	animator.play(mode)
	animator.connect("animation_finished", self, "_fadeEnd")
	
func _fadeEnd(anim_name):
	if anim_name == "in":
		emit_signal("fade_finished", mode)
		
	Renderer.transition = null
	queue_free()
