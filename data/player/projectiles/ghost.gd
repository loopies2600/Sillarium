extends Area2D

onready var ghost = $Ghost
onready var hitbox = $CollisionShape2D
onready var lifeTime = $LifeTime
onready var anim = $Animator

export (int) var speed = 400
export (int) var steerStrength = 75

var target = null

var velocity := Vector2.ZERO
var acceleration := Vector2.ZERO

func _ready():
	start(self.transform, $TargetTest)
	var _unused = connect("body_entered", self, "_bodyEnter")
	_unused = connect("area_entered", self, "_areaEnter")
	_unused = lifeTime.connect("timeout", self, "kill")
	
func start(_transform, _target):
	target = _target
	global_transform = _transform
	velocity = transform.x * speed
	
func seek():
	var steer = Vector2.ZERO
	
	if target:
		var desired = (target.position - position).normalized() * speed
		steer = (desired - velocity).normalized() * steerStrength
		
	return steer
	
func _physics_process(delta):
	acceleration += seek()
	velocity += acceleration * delta
	velocity = velocity.clamped(speed)
	rotation = velocity.angle()
	position += velocity * delta
	
func _bodyEnter(_body):
	kill()
	
func _areaEnter(_area):
	kill()
	
func kill():
	set_physics_process(false)
	self.anim.play("Die")
	hitbox.disabled = true
