extends Hazard

export (float) var fallMultiplier = rand_range(1, 2)

onready var sprite = $PickyPick

func _ready():
	set_physics_process(false)
	hitbox = $Hitbox
	
	yield(get_tree().create_timer(4), "timeout")
	set_physics_process(true)
	
func _physics_process(delta):
	velocity.y += Globals.GRAVITY * fallMultiplier
	
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		if collision.normal != Vector2.LEFT || collision.normal != Vector2.RIGHT:
			_destroy()
	
func _destroy():
	emit_signal("camera_shake_requested")
	emit_signal("destroyed")
	Renderer.spawn4Piece(sprite, Globals.toVec2(0.75))
	queue_free()
