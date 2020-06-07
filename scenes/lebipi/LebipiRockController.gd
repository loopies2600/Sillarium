extends Area2D

# Variables para velocidad de la caida
export (float) var acceleration = 40
export (float) var maxSpeed = 600

# Variable de velocidad y si puede caer
var velocity = Vector2()
var canDrop = false

func _ready():
	# Cuando sale de la pantalla, OnScreenExited() es llamado
	$VisibilityNotifier2D.connect("screen_exited", self, "OnScreenExited")

func _physics_process(delta):
	# Mueve la piedra
	position += velocity * delta
	
	# si puede caer, acelera la piedra hasta la velocidad maxima
	if canDrop:
		velocity.y = min(velocity.y + acceleration, maxSpeed)

func Drop():
	# Deja que la piedra caiga
	canDrop = true

func OnScreenExited():
	# Si la piedra esta cayendo y esta fuera de la pantalla, se borra
	if canDrop:
		queue_free()
