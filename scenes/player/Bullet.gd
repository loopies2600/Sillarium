extends Area2D

export (Vector2) var speed = Vector2(700, 0)

var velocity = Vector2()

func _ready():
	velocity = speed.rotated(rotation)
	$VisibilityNotifier2D.connect("screen_exited", self, "OnScreenExited")
	$Sprite.rotate(-global_rotation)

func _physics_process(delta):
	position += velocity * delta
	$Sprite.rotation_degrees += 16

func OnScreenExited():
	queue_free()
