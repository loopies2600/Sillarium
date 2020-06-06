extends KinematicBody2D

export (float) var gravity = 20
export (float) var maxSpeed = 300

var velocity = Vector2()
var dropping = true

func _ready():
	pass

func _physics_process(delta):
	move_and_slide(velocity, Globals.UP)
	if is_on_floor():
		$DeleteTimer.start()
		dropping = false
	if dropping:
		velocity.y = min(velocity.y + gravity, maxSpeed)
	else:
		
		velocity = Vector2()

func OnTimerTimeout():
	queue_free()
