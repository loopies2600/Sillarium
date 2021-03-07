extends CanvasLayer

onready var rect = $TextureRect
onready var flipTimer = $FlipTimer

func _ready():
	flipTimer.connect("timeout", self, "_flip")
	
func _flip():
	flipTimer.wait_time = rand_range(1.0, 2.0)
	rect.flip_h = !rect.flip_h
