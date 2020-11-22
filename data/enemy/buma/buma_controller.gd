extends "../basic_enemy_controller.gd"

# Child nodes
onready var animPlayer = $Graphics/AnimationPlayer
onready var boomerangStartPos = $BoomerangStartPosition.global_position
onready var throwTimer = $ThrowTimer

# Variables para el bumerang
export (PackedScene) var boomerang
export (float) var initialSpeed = 500
export (float) var speedDecrease = 5
export (float) var throwTime = 1

# Variables para la muerte
export (Vector2) var initialDeathBump = Vector2(250, -500)
export (Vector2) var deathFallSpeed = Vector2(0, 40)

var hasBoomerang = true
var killed = false
var velocity = Vector2()
var dir = 1

func _ready():
	# Conecta funciones
	throwTimer.connect("timeout", self, "OnThrowTimerTimeout")
	connect("area_entered", self, "OnHitboxEntered")
	connect("DestroySelf", self, "OnDestruction")
	
	# Empieza el timer
	throwTimer.wait_time = throwTime
	throwTimer.start()
	
	velocity = initialDeathBump
	
	PlayIdleAnimation()
	
	match scale.x:
			1.0:
				dir = 1
			-1.0:
				dir = -1
				

func _physics_process(delta):
	if killed:
		position += velocity * delta
		velocity += deathFallSpeed
		
		scale.y += 0.1
		scale.x += 0.1 * dir
		# modulate -= Color(-0.05, 0.05, 0.05, 0)
		rotation_degrees += 25
			
func CreateBoomerang():
	# Pone la animacion correcta
	animPlayer.play("WaitingForCatch")
	
	# Crea el bumerang
	var newBoomerang = boomerang.instance()
	get_tree().get_root().add_child(newBoomerang)
	hasBoomerang = false
	
	# Cambia a la velocidad y rotacion
	newBoomerang.scale = scale
	newBoomerang.global_position = boomerangStartPos
	newBoomerang.velocity = Vector2(initialSpeed, 0)
	newBoomerang.velocityDecrease = Vector2(-speedDecrease, 0)

func OnThrowTimerTimeout():
	# La animacion automaticamente llama "CreateBoomerang()"
	#animPlayer.play("Throw")
	pass

func OnHitboxEntered(area):
	# Si un bumerang entra, lo borra
	if area.is_in_group("Boomerang") and !hasBoomerang:
		area.get_parent().queue_free()
		hasBoomerang = true
		
		# Reinicia el buma
		animPlayer.play("Catching")
		throwTimer.start()

func PlayIdleAnimation():
	animPlayer.play("Idle")

func DisableHitbox():
	$CollisionShape2D.disabled = true

func DeleteSelf():
	queue_free()

func OnDestruction():
	killed = true
	throwTimer.stop()
	call_deferred("DisableHitbox")
	animPlayer.play("Killed")
