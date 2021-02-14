extends Camera2D

# pulso
onready var beatTimer : Timer = $BeatTimer
onready var BPM = Audio.getMusicBPM(Objects.currentWorld.musicID)

var speed = 0.1
var intensity = 0.9

export var doBeat := true

# vibración
onready var shakeTimer : Timer = $ShakeTimer

export var amplitude := 8.0
export var duration := 0.25 setget setShakeDuration
export(float, EASE) var DAMP_EASING := 1.0
export var shake := false setget setShaking

export var enabled := true

func _ready():
	randomize()
	set_process(false)
	self.duration = duration
	connectToManipulators()
	
	if doBeat:
		beatTimer.wait_time = 60.0 / BPM
		beatTimer.start()
		beatTimer.connect("timeout", self, "_onBeat")
		
func _process(delta):
	if doBeat:
		zoom = lerp(zoom, Vector2(1.0, 1.0), speed)
		
	var damping := ease(shakeTimer.time_left / shakeTimer.wait_time, DAMP_EASING)
	offset = Vector2(
		rand_range(amplitude, -amplitude) * damping,
		rand_range(amplitude, -amplitude) * damping
	)
	
func _onShakeTimeout():
	self.shake = false
	
func _onShakeRequest():
	if not enabled:
		return
	self.shake = true
	
func setShakeDuration(value: float):
	duration = value
	shakeTimer.wait_time = duration
	
func setShaking(boolean: bool):
	shake = boolean
	set_process(shake)
	offset = Vector2()
	
	if shake:
		shakeTimer.start()
		
func connectToManipulators():
	for cameraManipulator in get_tree().get_nodes_in_group("CameraManipulator"):
		cameraManipulator.connect("camera_shake_requested", self, "_onShakeRequest")
		cameraManipulator.connect("beat", self, "_onBeat")
	
func _beat():
	zoom = Vector2(intensity, intensity)
	beatTimer.wait_time = Engine.get_frames_per_second() / BPM
	
func _onBeat():
	_beat()
	_onShakeRequest()
