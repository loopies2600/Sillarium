extends "../behaviour/basic_enemy_controller.gd"

onready var renderer = $Graphics
onready var tongue = $Graphics/Tongue
onready var tongueTipPos = $Graphics/Tongue/TipPos
onready var tongueTip = $Graphics/TongueArea
onready var anim = $Graphics/AnimationPlayer

export (int) var tongueSpeed = 8

var isGrabbing = false
var currentBody = null

func _ready():
	var _unused = tongueTip.connect("body_entered", self, "_grab")
	_unused = tongueTip.connect("body_exited", self, "_drop")
	hitbox = $Area2D
	
func _process(delta):
	tongueTipPos.position.y = -1 * tongue.scale.y
	tongueTip.position = tongueTipPos.position
	
func _grab(body):
	if !isGrabbing:
		currentBody = body
		currentBody.z_index = -4096
		isGrabbing = true
	
func _drop(_body):
	if isGrabbing:
		currentBody = null
		currentBody.z_index = 0
		isGrabbing = false
		
func OnBodyEntered(body):
	currentBody.visible = false
	
func OnBodyExited(body):
	currentBody.visible = true
