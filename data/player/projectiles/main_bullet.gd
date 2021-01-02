extends Area2D

onready var sprite = $Sprite
onready var dust = preload("res://sprites/character/prota_test/test_dust.png")

export (Vector2) var speed = Vector2(1500, 0)

var velocity = Vector2()
var spn = 0

func _ready():
	set_process(false)
	velocity = speed.rotated(rotation)
	connect("body_entered", self, "OnBodyEntered")
	$VisibilityNotifier2D.connect("screen_exited", self, "OnScreenExited")

func _physics_process(delta):
	Globals.CreateTrail(0.2, sprite.texture, sprite.global_position, sprite.global_rotation, sprite.global_scale, z_as_relative)
	position += velocity * delta

func _process(delta):
	deathStuff(delta)
	
func OnBodyEntered(body):
	set_process(true)

func OnScreenExited():
	queue_free()
	
func deathStuff(delta):
	set_physics_process(false)
	sprite.texture = dust
	sprite.region_enabled = true
	sprite.region_rect = Rect2(32 * floor(spn), 0, 32, 32)
	sprite.scale += Vector2(delta * 4, delta * 4)
	spn += 0.5
	modulate.a -= delta * 4
	
	if modulate.a < 0:
		queue_free()
