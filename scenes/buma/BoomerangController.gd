extends Node2D

# Child nodes
onready var hitbox = $Area2D
onready var sprite = $Area2D/Sprite
onready var startPos = $StartPosition.position
onready var visibility = $Area2D/VisibilityNotifier2D

# Movimiento
export (float) var initialSpeed = 500
export (float) var speedDecrease = 5
export (float) var rotationSpeed = 0.3
export (float) var gravity = 20

# Velocidad
var velocity = Vector2()
var velocityDecrease
var falling = false
var xPosition

func _ready():
	# Conectando funciones
	visibility.connect("screen_exited", self, "OnScreenExited")

func _physics_process(delta):
	# Gira la sprite
	sprite.rotation += rotationSpeed
	
	# Cambia la velocidad
	if !falling:
		velocity += velocityDecrease
	
	xPosition = hitbox.position.rotated(-rotation).x
	print(xPosition)
	
	# Chequea que si ha llegado a la posicion inicial
	CheckPosition()
	
	# Mueve la posicion (no usa move_and_slide() porque no
	# es un KB2D)
	hitbox.position += velocity * delta

func CheckPosition():
	# Si ha llegado a la posicion inicial se borra
	if xPosition < startPos.x:
		falling = true
		hitbox.monitoring = false
		hitbox.monitorable = false
		rotationSpeed = 0
		velocity = Vector2(lerp(velocity.x, 0, 0.1), velocity.y + gravity)

func OnScreenExited():
	# Si esta cayendo y sale de la pantalla es borrado
	if falling:
		print("AAA")
		queue_free()

func OnBodyEntered(body):
	pass
