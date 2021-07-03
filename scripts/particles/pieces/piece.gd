extends KinematicBody2D

export (float, 0, 1) var bounciness = 0.75

onready var shadow = $Shadow
onready var sprite = $Sprite
onready var hitbox = $Hitbox
onready var visibility = $VisibilityNotifier2D

var initialVel := Vector2()
var rotationMultiplier := 0.00025
var velocity

func _ready():
	sprite.set_material(sprite.get_material().duplicate())
	visibility.connect("screen_exited", self, "_screenExit")
	
func _physics_process(delta):
	hitbox.shape.extents = sprite.region_rect.size / 2
	
	velocity.y += Globals.GRAVITY
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		velocity = velocity.bounce(collision.normal)
		velocity *= bounciness
		
	if velocity.abs() <= Vector2(0.75, 0.75):
		sprite.get_material().set_shader_param("opacity", sprite.get_material().get_shader_param("opacity") * 0.9)
		
	if sprite.get_material().get_shader_param("opacity") <= 0.05:
		_kill()
		
func _screenExit():
	_kill()
	
func _kill():
	queue_free()
