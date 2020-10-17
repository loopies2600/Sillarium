extends Polygon2D

var speed = 2
var spread = 2
var startPos = Vector2()
var limit
var wind
var movementMode

func _ready():
	position = startPos
	
func _physics_process(delta):
	_applyVelocity(movementMode)
	
func _applyVelocity(mode):
	match mode:
		0:
			position.x += -speed - wind
	
			if (position.x < 0):
				position.x = limit
		1:
			position.x += speed + wind
	
			if (position.x > limit):
				position.x = 0

