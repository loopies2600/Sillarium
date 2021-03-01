extends KinematicBody2D

export (float, 0, 1) var bounceOff = 0.75

onready var sprite = $Sprite
onready var hitbox = $Hitbox
onready var visibility = $VisibilityNotifier2D

var initialVel = Vector2()
var velocity

func _ready():
	visibility.connect("screen_exited", self, "_screenExit")
	
func _physics_process(delta):
	hitbox.shape.extents = sprite.region_rect.size / 2
	
	velocity.y += Globals.GRAVITY * delta
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		velocity = velocity.bounce(collision.normal)
		velocity *= bounceOff
		
	if velocity.abs() <= Vector2(0.5, 0.5):
		sprite.visible = !sprite.visible
	if velocity.abs() <= Vector2(0.1, 0.1):
		_kill()
		
func _screenExit():
	_kill()
	
func _kill():
	queue_free()
