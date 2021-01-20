extends Area2D

export (float) var speed = 1000

var velocity = Vector2()

func _ready():
	velocity.x = speed
	velocity = velocity.rotated(global_rotation)
	
	var _unused = connect("body_entered", self, "OnEnvironmentEnter")

func _physics_process(delta):
	position += velocity * delta

func OnEnvironmentEnter(_body):
	queue_free()
