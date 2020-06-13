extends Area2D

# Child nodes
onready var animPlayer = $Graphics/Legs/AnimationPlayer
onready var boomerangStartPos = $BoomerangStartPosition.position
onready var throwTimer = $ThrowTimer

# Variables para el bumerang
export (PackedScene) var boomerang
export (float) var initialSpeed = 500
export (float) var speedDecrease = 5
export (float) var throwTime = 1
export (float) var direction = 0

var hasBoomerang = true

func _ready():
	# Conecta funciones
	throwTimer.connect("timeout", self, "OnThrowTimerTimeout")
	connect("area_entered", self, "OnAreaEntered")
	
	# Empieza el timer
	throwTimer.wait_time = throwTime
	throwTimer.start()
	
	PlayIdleAnimation()

func CreateBoomerang():
	# Pone la animacion correcta
	animPlayer.play("WaitingForCatch")
	
	# Crea el bumerang
	var newBoomerang = boomerang.instance()
	add_child(newBoomerang)
	hasBoomerang = false
	
	# Cambia a la velocidad y rotacion 
	newBoomerang.global_rotation = direction
	newBoomerang.position = boomerangStartPos
	newBoomerang.velocity = Vector2(initialSpeed, 0)
	newBoomerang.velocityDecrease = Vector2(-speedDecrease, 0)
	

func OnThrowTimerTimeout():
	# La animacion automaticamente llama "CreateBoomerang()"
	animPlayer.play("Throw")

func OnAreaEntered(area):
	# Si un bumerang entra, lo borra
	if area.is_in_group("Boomerang") and !hasBoomerang:
		area.get_parent().queue_free()
		hasBoomerang = true
		
		# Reinicia el buma
		animPlayer.play("Catching")
		throwTimer.start()

func PlayIdleAnimation():
	animPlayer.play("Idle")
