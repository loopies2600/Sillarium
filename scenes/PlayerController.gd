extends KinematicBody2D

onready var animPlayer = $Graphics/AnimationPlayer

export (float) var gravity = 200

var velocity = Vector2()

func _ready():
	animPlayer.play("PlayerIdle")

func _physics_process(delta):
	velocity = move_and_slide(velocity, Globals.UP)
	velocity.y = gravity
	
