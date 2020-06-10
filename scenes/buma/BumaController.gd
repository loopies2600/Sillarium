extends Area2D

onready var animPlayer = $Graphics/Legs/AnimationPlayer
onready var boomerangStartPos = $BoomerangStartPosition.position

export (PackedScene) var boomerang
export (float) var initialSpeed = 500
export (float) var speedDecrease = 5
 
var hasBoomerang = true

func _ready():
	ThrowBoomerang()

func ThrowBoomerang():
	animPlayer.play("WaitingForCatch")
	
	var newBoomerang = boomerang.instance()
	add_child(newBoomerang)
	
	# Cambia la velocidad a la rotacion correcta
	newBoomerang.position = boomerangStartPos
	newBoomerang.velocity = Vector2(initialSpeed, 0).rotated(rotation)
	newBoomerang.velocityDecrease = Vector2(-speedDecrease, 0).rotated(rotation)

func OnAreaEntered(area):
	pass
