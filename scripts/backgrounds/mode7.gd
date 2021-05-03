extends ParallaxBackground

onready var layers := [$Layer0, $Layer1, $Layer2, $Layer3, $Layer4, $Layer5, $Layer6, $Layer7, $Layer8, $Layer9, $Layer10, $Layer11]

func _ready():
	for lay in range(layers.size()):
		var div = 1.0 / layers.size()
		var finalVal = div * lay
		
		layers[lay].motion_scale = Vector2(1 - finalVal, 0)
		
		for c in layers[lay].get_children():
			c.modulate = Color(finalVal, finalVal, finalVal * 2, 1)
