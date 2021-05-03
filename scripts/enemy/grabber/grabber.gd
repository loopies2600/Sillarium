extends "../behaviour/basic_enemy_controller.gd"

onready var renderer = $Graphics
onready var sprite = $Graphics/Body
onready var tongue = $Graphics/Tongue
onready var tongueTipPos = $Graphics/Tongue/TipPos
onready var tongueTip = $Graphics/TongueArea
onready var anim = $Graphics/AnimationPlayer

export (int) var tongueSpeed = 8

var isGrabbing = false
var currentBody = null

func _ready():
	add_to_group("Enemy")
	var _unused = connect("destroyed", self, "OnDestruction")
	_unused = tongueTip.connect("body_entered", self, "_grab")
	_unused = tongueTip.connect("body_exited", self, "_drop")
	
	hitbox = $Area2D
	
func _process(_delta):
	tongueTipPos.position.y = -1 * tongue.scale.y
	tongueTip.position = tongueTipPos.position
	
func _grab(body):
	if !isGrabbing:
		currentBody = body
		currentBody.z_index = -4096
		isGrabbing = true
	
func _drop(_body):
	if isGrabbing:
		currentBody.z_index = 0
		currentBody = null
		isGrabbing = false
		
# warning-ignore:unused_argument
func OnBodyEntered(body):
	if currentBody != null:
		currentBody.visible = false
	
# warning-ignore:unused_argument
func OnBodyExited(body):
	if currentBody != null:
		currentBody.visible = true
		
func OnDestruction():
	emit_signal("camera_shake_requested")
	Renderer.spawn4Piece(sprite)
	queue_free()
