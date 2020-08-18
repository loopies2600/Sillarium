extends Area2D

onready var sprite = $Sprite

export (Vector2) var speed = Vector2(1500, 0)

var velocity = Vector2()

func _ready():
	velocity = speed.rotated(rotation)
	connect("body_entered", self, "OnBodyEntered")
	$VisibilityNotifier2D.connect("screen_exited", self, "OnScreenExited")

func _physics_process(delta):
	Globals.CreateTrail(0.15, sprite.texture, sprite.global_position, sprite.global_rotation, z_as_relative)
	position += velocity * delta

func OnBodyEntered(body):
	queue_free()

func OnScreenExited():
	queue_free()
