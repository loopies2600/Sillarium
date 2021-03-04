extends Camera2D

onready var enabled = Settings.getSetting("renderer", "camera_effects")
onready var shakeTimer : Timer = $ShakeTimer

export var amplitude := 8.0
export var duration := 0.25 setget setShakeDuration
export(float, EASE) var DAMP_EASING := 1.0
export var shake := false setget setShaking

func _ready():
	if owner is Player:
		owner.connect("player_grounded_updated", self, "_playerGrounded")
	
	randomize()
	set_process(false)
	self.duration = duration
	
func _process(delta):
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
	
func _playerGrounded(isGrounded):
	drag_margin_v_enabled = !isGrounded
	
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
