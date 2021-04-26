extends Kinematos

# Variables para velocidad de la caida
export (float) var acceleration = 40
export (float) var maxSpeed = 600
export (float) var horDrag = 0.5
export (float) var pushSpeed = 0.25

# Variable de velocidad y si puede caer
var canDrop = false

func _ready():
	pass

func _physics_process(_delta):
	# Detiene a la piedra horizontalmente
	velocity.x = lerp(velocity.x, 0, horDrag)
	
	# si puede caer, acelera la piedra hasta la velocidad maxima
	if canDrop:
		velocity.y = min(velocity.y + acceleration, maxSpeed)
	
	# Mueve la piedra
	velocity = move_and_slide(velocity)

func Push(xVelocity):
	# Cambia la velocidad horizontal de la piedra
	velocity.x = xVelocity * pushSpeed

func Drop():
	# Deja que la piedra caiga
	canDrop = true

func OnScreenExited():
	# Si la piedra esta cayendo y esta fuera de la pantalla, se borra
	if canDrop:
		queue_free()
