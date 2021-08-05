extends Hazard

onready var sprite = $PickyPick

func _ready():
	set_physics_process(false)
	hitbox = $Hitbox
	
	yield(get_tree().create_timer(4), "timeout")
	set_physics_process(true)
	
func mainMotion(delta):
	velocity.y += Globals.GRAVITY * fallMultiplier
	
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		if collision.normal != Vector2.LEFT || collision.normal != Vector2.RIGHT:
			_destroy()
	
func _destroy():
	emit_signal("camera_shake_requested")
	emit_signal("destroyed")
	queue_free()
