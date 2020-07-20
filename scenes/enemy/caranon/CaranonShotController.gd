extends Area2D

onready var visibility = $VisibilityNotifier2D

var speed
var velocity = Vector2()

func _ready():
	visibility.connect("screen_exited", self, "OnScreenExit")
	connect("body_entered", self, "OnBodyEntered")
	velocity = speed.rotated(rotation)

func _physics_process(delta):
	position += velocity * delta
	if speed.y != 0: velocity.y += 10

func OnBodyEntered(body):
	if body.is_in_group("Player"):
		body.Respawn()
	else:
		queue_free()

func OnScreenExit():
	queue_free()
