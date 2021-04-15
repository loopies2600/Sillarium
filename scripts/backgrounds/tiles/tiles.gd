extends CanvasLayer

onready var rects = [$Tiles0, $Tiles1]
onready var flipTimer = $FlipTimer

func _ready():
	Audio.connect("pump", self, "_flip")
	
func _flip(_beatNo):
	for rect in rects:
		rect.flip_h = !rect.flip_h
