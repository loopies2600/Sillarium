extends Node2D

# Variables de otros objetos
onready var animationPlayer = $KinematicBody2D/Graphics/AnimationPlayer
onready var tween = $Tween
onready var lebipi = $KinematicBody2D
onready var debugPos = $KinematicBody2D/Graphics/DebugPosition
onready var debugFollow = $KinematicBody2D/Graphics/DebugFollow

# Variables para el movimiento
export (Vector2) var endPoint = Vector2(320, 0)
export (float) var speed = 1
export (float) var idleTime = 0.5
export (float) var smoothing = 0.05

# Posicion en la que empieza el kinematicbody2d
var positionToFollow = Vector2.ZERO

func _ready():
	# Pone la animacion y el tween para que se mueva
	animationPlayer.play("lebipi_jittering")
	InitializeTween()
	
	# Debug stuff
	if Globals.debug:
		debugPos.show()
		debugFollow.show()

func _physics_process(_delta):
	# No entiendo completamente como funciona, pero esto hace que se mueva de manera lisa ya que
	# en realidad, la posicion de lebipi sigue a "positionToFollow", y cuando se acerca mas, se mueve mas lento
	lebipi.position = lebipi.position.linear_interpolate(positionToFollow, smoothing)
	
	# Debug stuff
	debugPos.position = position
	debugFollow.position = positionToFollow

func InitializeTween():
	# El tiempo que toma ir del empezar a la posicion final
	var duration = endPoint.length() / float(speed * 64)
	
	# Crea el tween para que se mueva y lo empieza
	# En vez de manipular la posicion directamente, cambia "positionToFollow"
	# Start -> End
	tween.interpolate_property(self, "positionToFollow", Vector2.ZERO, endPoint, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, idleTime)
	# End -> Start
	# (note que lo unico que cambia es poner poner la posicion del empezar y el final al reves, y alargar el tiempo que dura en empezar)
	tween.interpolate_property(self, "positionToFollow", endPoint, Vector2.ZERO, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, duration + idleTime * 2)
	tween.start()
