extends AnimatedSprite

onready var animator = $Animations

var anim
var delay
var toPos

func _ready():
	animator.connect("animation_finished", self, "_animEnd")
	
func _process(delta):
	if delay < 0:
		animator.play(anim)
	else:
		delay -= delta

	position = lerp(position, toPos, delta * 4)
	
func _animEnd(anim):
	set_process(false)
