extends Camera2D

onready var BPM = Audio.getMusicBPM(Objects.currentWorld.musicID)
var speed = 0.1
var intensity = 0.9

onready var beatTimer = $BeatTimer

func _ready():
	_beat()
	beatTimer.connect("timeout", self, "_onBeat")
	
func _process(delta):
	zoom = lerp(zoom, Vector2(1.0, 1.0), speed)
	
func _beat():
	zoom = Vector2(intensity, intensity)
	beatTimer.wait_time = Engine.get_frames_per_second() / BPM
	
func _onBeat():
	_beat()
