extends Area2D

onready var sprite = $Sprite
onready var dust = preload("res://data/player/projectiles/dust.tscn")

export (Vector2) var speed = Vector2(1500, 0)

var color = Color.lightyellow
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

func OnBodyEntered(body):
	kill()

func OnScreenExited():
	queue_free()
	
func kill():
	var newDust = dust.instance()
	get_tree().get_root().add_child(newDust)
	newDust.modulate = color
	newDust.position = position
	queue_free()
