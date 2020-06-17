extends "res://scenes/enemy/BasicEnemyController.gd"

onready var animPlayer = $AnimationPlayer
onready var hitbox = $CollisionShape2D

export (float) var fallSpeed = 20

var velocity = Vector2()
var falling

func _ready():
	connect("DestroySelf", self, "OnDestruction")
	$Sprite/VisibilityNotifier2D.connect("screen_exited", self, "OnScreenExited")
	animPlayer.play("Swinging")

func _process(delta):
	if falling:
		velocity.y += fallSpeed
		position += velocity * delta

func StartFalling():
	falling = true
	call_deferred("DisableHitbox")

func DisableHitbox():
	hitbox.disabled = true

func OnScreenExited():
	queue_free()

func OnDestruction():
	animPlayer.play("Exploding")
