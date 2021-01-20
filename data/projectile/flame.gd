extends Node2D

onready var fire = $Fire
onready var dust = preload("res://data/player/projectiles/dust.tscn")

export (float) var initialSpeed = 500
export (float) var speedDecrease = 20

var color = Color.lightyellow
var sizeLimit = 3
var timeMultiplier = 0.05

var velocity = Vector2(initialSpeed, 0.0)
var velocityDecrease = Vector2(speedDecrease, 0.0)

func _ready():
	fire.connect("body_entered", self, "OnBodyEntered")
	var _unused = $Fire/VisibilityNotifier2D.connect("screen_exited", self, "OnScreenExited")
	fire.rotation -= rotation
	scale = Vector2.ZERO
	
func _physics_process(delta):
	velocity = Vector2(max(velocity.x - velocityDecrease.x, 0.0), velocity.y - velocityDecrease.y)
	
	scale += Vector2(timeMultiplier, timeMultiplier)
	modulate -= Color(timeMultiplier / sizeLimit, timeMultiplier / sizeLimit, timeMultiplier / sizeLimit * 1.2, timeMultiplier / sizeLimit)
	
	if modulate.a <= 0.25:
		kill()
		
	fire.position += velocity * delta
	
func OnBodyEntered(_body):
	kill()

func OnScreenExited():
	queue_free()
	
func kill():
	var newDust = dust.instance()
	get_tree().get_root().add_child(newDust)
	newDust.position = fire.global_position
	newDust.modulate = color
	newDust.scale = scale
	queue_free()
