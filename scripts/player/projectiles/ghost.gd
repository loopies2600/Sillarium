extends Projectile

onready var ghost = $Ghost
onready var hitbox = $CollisionShape2D
onready var lifeTime = $LifeTime
onready var anim = $Animator

export (int) var damage = 10
export (float) var speed = 400
export (float) var steerStrength = 75

var papa
var target = null

var velocity := Vector2.ZERO
var acceleration := Vector2.ZERO

func _ready():
	velocity = transform.x * speed
	
	var _unused = connect("body_entered", self, "_bodyEnter")
	_unused = connect("area_entered", self, "_areaEnter")
	_unused = lifeTime.connect("timeout", self, "kill")
	
func setTarget(_target):
	target = _target
		
func seek():
	var steer = Vector2.ZERO
	
	if target:
		var desired = (target.position - position).normalized() * speed
		steer = (desired - velocity).normalized() * steerStrength
		
	return steer
	
func _physics_process(delta):
	setTarget(Objects.getClosestOrFurthest(self, "Enemy"))
	
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
