extends Node2D

onready var fire = $Fire

export (float) var initialSpeed = 500
export (float) var speedDecrease = 20

var sizeLimit = 3
var timeMultiplier = 0.075

var velocity = Vector2(initialSpeed, 0.0)
var velocityDecrease = Vector2(speedDecrease, 0.0)

func _ready():
	scale = Vector2.ZERO
	
func _physics_process(delta):
	velocity.x = max(velocity.x - velocityDecrease.x, 0.0)
	
	scale += Vector2(timeMultiplier, timeMultiplier)
	modulate.a -= timeMultiplier / sizeLimit
	
	if modulate.a <= 0.25:
		queue_free()
		
	fire.position += velocity * delta
