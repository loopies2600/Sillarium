extends AnimatedSprite

onready var animator = $Animations

var anim
var delay

func _ready():
	visible = false
	animator.connect("animation_finished", self, "_animEnd")
	yield(get_tree().create_timer(delay), "timeout")
	visible = true
	animator.play(anim)
	
func _animEnd(_anim):
	set_process(false)
	
	yield(get_tree().create_timer(2 - delay * 2), "timeout")
	animator.play("Disappear")
