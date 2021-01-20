extends Node2D

func _ready():
	pass

func HandleInput(player, _delta):

	# Velocidad local para recibir input
	var inputVelocity = Vector2()

	if Input.is_action_pressed("move_left"):
		inputVelocity.x = -1
		player.FlipGraphics(true)
	if Input.is_action_pressed("move_right"):
		inputVelocity.x = 1
		player.FlipGraphics(false)
	if Input.is_action_pressed("jump"):
		if player.is_on_floor():
			player.velocity.y = -player.jumpBoost

	# Cambia estado si no hay input
	if inputVelocity == Vector2() and player.velocity.y == 0:
		player.velocity.x = 0
		return "Idle"
	else:

		# Decide cual animacion usar
		if player.is_on_floor():
			player.anim.animation = "Running"
		else:
			if player.velocity.y >= 0:
				player.anim.animation = "Falling"
			else:
				player.anim.animation = "Jumping"
		
		# Annade la velocidad local a la velocidad real
		player.velocity.x = inputVelocity.x * player.horSpeed
