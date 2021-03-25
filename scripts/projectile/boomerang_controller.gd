extends Node2D

# Child nodes
onready var hitbox = $Area2D
onready var sprite = $Area2D/Sprite
onready var startPos = $StartPosition.position
onready var visibility = $Area2D/VisibilityNotifier2D

onready var dust = preload("res://data/player/projectiles/dust.tscn")

export (int) var damage = 2
# Movimiento
export (float) var initialSpeed = 500
export (float) var speedDecrease = 5
export (float) var rotationSpeed = 1
export (float) var gravity = 20

# Velocidad
var velocity = Vector2()
var velocityDecrease = Vector2()
var falling = false
var distanceToStartPoint

func _ready():
	# Conectando funciones
	visibility.connect("screen_exited", self, "OnScreenExited")
	hitbox.connect("body_entered", self, "OnBodyEntered")

func _physics_process(delta):
	# Gira la sprite
	sprite.rotation += rotationSpeed
	
	# Cambia la velocidad
	if !falling:
		Objects.spawn(21, {"global_position" : sprite.global_position})
		Renderer.spawnTrail(0.1, sprite)
		velocity += velocityDecrease
	
	# Obtiene la distancia del inicio al bumerang
	distanceToStartPoint = hitbox.position.rotated(-rotation).x - startPos.rotated(-rotation).x
	
	# Mueve la posicion (no usa move_and_slide() porque no
	# es un KB2D)
	hitbox.position += velocity * delta

func CheckPosition():
	# Si ha llegado a la posicion empieza a caer
	if distanceToStartPoint < 0 and !falling:
		falling = true
		# Desactiva la hitbox
		hitbox.monitoring = false
		hitbox.monitorable = false
		rotationSpeed = 0
		global_rotation = 0
		velocity = Vector2()
	
	# Cae
	if falling:
		velocity = Vector2(0, velocity.y + gravity)

func OnScreenExited():
	queue_free()

func OnBodyEntered(body):
	if body.is_in_group("Player"):
		body.takeDamage(damage, -velocity.x)
