extends CanvasLayer

signal fade_started(m)
signal fade_finished(m)

onready var rect = $ViewportTexture
onready var animator = $Animator

export (String) var type = "mode7"

var mode = "in"
var tex

func _ready(): 
	emit_signal("fade_started", mode)
	rect.texture = tex
	animator.play(type + mode)
	animator.connect("animation_finished", self, "_fadeEnd")
	
func _fadeEnd(anim_name):
	if anim_name == type + "in":
		emit_signal("fade_finished", mode)
		
	Renderer.transition = null
	queue_free()
