extends Area2D

onready var sprite = $Sprite
onready var hitbox = $Hitbox

var speed = Vector2()
var velocity = Vector2()

func _ready():
	velocity = speed.rotated(rotation)
	
func _physics_process(delta):
	hitbox.shape.extents = Vector2(sprite.texture.get_width() / 2, sprite.texture.get_height() / 2)
	position += velocity * delta
	Globals.CreateTrail(0.2, sprite.texture, sprite.global_position, sprite.global_rotation, sprite.global_scale, z_as_relative)
