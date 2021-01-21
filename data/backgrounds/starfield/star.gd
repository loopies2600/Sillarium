extends Sprite

var speed = 2
var spread = 2
var startPos = Vector2()
var limit
var wind
var movementMode

func _ready():
	position = startPos
	
func _physics_process(_delta):
	if movementMode != null:
		_applyVelocity(movementMode)
	
func _applyVelocity(mode):
	match mode:
		0:
			position.x += -speed - wind
	
			if (position.x < 0):
				wind = rand_range(4, 8)
				position.y = randi() % int(limit.y)
				position.x = limit.x
		1:
			position.x += speed + wind
	
			if (position.x > limit.x):
				wind = rand_range(4, 8)
				position.y = randi() % int(limit.y)
				position.x = 0
