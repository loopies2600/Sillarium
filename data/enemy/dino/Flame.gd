extends Node2D

onready var fire = $Fire

export (float) var initialSpeed = 500
export (float) var speedDecrease = 20

var dir = 1
var sizeLimit = 4
var timeMultiplier = 0.075

var velocity = Vector2(initialSpeed, 100)
var velocityDecrease = Vector2(speedDecrease * dir, speedDecrease / (sizeLimit / 2))

func _ready():
	scale = Vector2.ZERO
	
func _physics_process(delta):
	velocity -= velocityDecrease
	
	scale += Vector2(timeMultiplier, timeMultiplier)
	modulate.a -= timeMultiplier / sizeLimit
	
	if modulate.a <= 0.25:
		queue_free()
		
	fire.position += velocity * delta
