extends ParallaxBackground

var speed = 20
onready var bg = $ParallaxLayer
var rng = RandomNumberGenerator.new()

func _process(delta):
	rng.randomize()
	var randomColor = rng.randf_range(0.5, 0.75)
	# WARNING: FLASHING COLORS
	$ParallaxLayer/BG.modulate.b = randomColor
	bg.motion_offset.y += speed * delta
	
	if (bg.motion_offset.y >= 600):
		bg.motion_offset.y = 0
