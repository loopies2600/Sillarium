extends ParallaxBackground

var speed = 0.5
onready var bg = $ParallaxLayer

func _process(delta):
	bg.motion_offset.y += speed
	
	if (bg.motion_offset.y >= 600):
		bg.motion_offset.y = 0
