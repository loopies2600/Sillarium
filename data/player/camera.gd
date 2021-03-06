extends Camera2D

const AHEAD_FACTOR = 0.15
const SHIFT_TRANS = Tween.TRANS_SINE
const SHIFT_EASE = Tween.EASE_OUT
const SHIFT_DURATION = 1.0

onready var previousPosition = get_camera_position()
onready var enabled = Settings.getSetting("renderer", "camera_effects")
onready var shakeTimer : Timer = $ShakeTimer
onready var tween : Tween = $Tween

export var amplitude := 16.0
export var duration := 0.25 setget setShakeDuration
export(float, EASE) var DAMP_EASING := 1.0
export var shake := false setget setShaking

enum shakingModes {HORIZONTAL = 1, VERTICAL = 2, BOTH = 0}
export (shakingModes) var shakeMode = 0

var facing = 0

func _ready():
	if owner is Player:
		var _unused = owner.connect("player_grounded_updated", self, "_playerGrounded")
	
	randomize()
	set_process(false)
	self.duration = duration
	
func _physics_process(_delta):
	_checkFacing()
	previousPosition = get_camera_position()
	
func _process(_delta):
	var damping := ease(shakeTimer.time_left / shakeTimer.wait_time, DAMP_EASING)
	
	match shakeMode:
		1:
			offset.x = rand_range(amplitude, -amplitude) * damping
		2:
			offset.y = rand_range(amplitude, -amplitude) * damping
		0:
			offset = Vector2(
				rand_range(amplitude, -amplitude) * damping,
				rand_range(amplitude, -amplitude) * damping
			)
	
func _checkFacing():
	var newFacing = sign(get_camera_position().x - previousPosition.x)
	
	if newFacing != 0 && facing != newFacing:
		facing = newFacing
		
		var targetOffset = get_viewport_rect().size.x * AHEAD_FACTOR * facing
		var _unused = tween.interpolate_property(self, "position:x", position.x, targetOffset, SHIFT_DURATION, SHIFT_TRANS, SHIFT_EASE)
		_unused = tween.start()
		
func _onShakeTimeout():
	self.shake = false
	
func _onShakeRequest(mode = 0, time = 0.25, amp = 16.0):
	if not enabled:
		return
		
	amplitude = amp
	self.duration = time
	shakeMode = mode
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
