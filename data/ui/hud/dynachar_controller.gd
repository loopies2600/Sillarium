extends AnimatedSprite

onready var animator = $Animations

var anim
var character
var delay
var toPos

func _ready():
	frame = character
	animator.connect("animation_finished", self, "_animEnd")
	
func _process(delta):
	if delay < 0:
		animator.play(anim)
	else:
		delay -= delta
	
	if frame != 28:
		frame = randi() % 28
	position = lerp(position, toPos, delta * 4)
	
func _animEnd(anim):
	set_process(false)
	frame = character
