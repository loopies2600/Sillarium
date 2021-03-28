extends Area2D

onready var dust = preload("res://data/player/projectiles/dust.tscn")

export (int) var damage = 5
export (bool) var hasGravity = false
export (Vector2) var speed = Vector2(750, 0)

onready var sprite : Sprite
onready var hitbox : CollisionShape2D

var color = Color.white
var papa
var velocity = Vector2()

func initialize():
	var _unused = connect("area_entered", self, "onAreaEntered")
	_unused = connect("body_entered", self, "onBodyEntered")
	_unused = connect("area_exited", self, "onAreaExited")
	_unused = connect("body_exited", self, "onBodyExited")
	
	# warning-ignore:integer_division
	# warning-ignore:integer_division
	# por qué esto es una alerta? no es como si rompiera el juego o algo...
	hitbox.shape.extents = Vector2(sprite.texture.get_width() / 2, sprite.texture.get_height() / 2)
	
	velocity = speed.rotated(rotation)
	
func _physics_process(delta):
	if hasGravity:
		velocity.y += Globals.GRAVITY * delta
		
	position += velocity * delta
	rotation = velocity.angle()
	
func onAreaEntered(_area):
	kill()
	
func onBodyEntered(_body):
	kill()
	
func onAreaExited(_area):
	pass
	
func onBodyExited(_body):
	pass
	
func kill():
	var newDust = dust.instance()
	newDust.modulate = color
	newDust.position = position
	get_tree().get_root().add_child(newDust)
	queue_free()
