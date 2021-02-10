extends Camera2D

var BPM = 90
var speed = 0.1
var intensity = 0.9

onready var beatTimer = $BeatTimer

func _ready():
	beatTimer.wait_time = Engine.get_frames_per_second() / BPM
	beatTimer.connect("timeout", self, "_onBeat")
	
func _process(delta):
	zoom = lerp(zoom, Vector2(1.0, 1.0), speed)
	
func _onBeat():
	zoom = Vector2(intensity, intensity)
	beatTimer.wait_time = Engine.get_frames_per_second() / BPM
