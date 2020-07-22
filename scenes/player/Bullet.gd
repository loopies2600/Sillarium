extends Area2D

onready var sprite = $Sprite

export (Vector2) var speed = Vector2(700, 0)

var velocity = Vector2()

func _ready():
	velocity = speed.rotated(rotation)
	connect("body_entered", self, "OnBodyEntered")
	$VisibilityNotifier2D.connect("screen_exited", self, "OnScreenExited")

func _physics_process(delta):
	position += velocity * delta

func OnBodyEntered(body):
	queue_free()

func OnScreenExited():
	queue_free()
