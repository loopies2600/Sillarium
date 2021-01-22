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
	var _unused = tongueTip.connect("body_entered", self, "_grabPlayer")
	hitbox = $Area2D
	
func _process(delta):
	tongueTipPos.position.y = -1 * tongue.scale.y
	tongueTip.position = tongueTipPos.position
	
func _grabPlayer(body):
	if body.is_in_group("Player") and !isGrabbing:
		currentBody = body
		isGrabbing = true
