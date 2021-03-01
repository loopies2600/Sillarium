extends "../behaviour/basic_enemy_controller.gd"

# Variables de otros objetos
onready var anim = $Graphics/AnimationPlayer
onready var tween = $Tween
onready var rock_child = $LebipiRock
onready var debugPos = $Graphics/DebugPosition
onready var debugFollow = $Graphics/DebugFollow
onready var renderer = $Graphics/Body
onready var rotor = $Graphics/Body/Rotor
onready var collisionBox = $Hitbox
onready var toPoint = [0, 320]

# Variables para el movimiento
export (Vector2) var endPoint = Vector2(320, 0)
export (float) var speed = 1
export (float) var idleTime = 0.5
export (float) var smoothing = 0.05

# Variable para el raycast y piedra
export (float) var rayLength = 512
var hasRock = true

# Posicion en la que empieza el kinematicbody2d
var positionToFollow = 0
var duration = 2

func _ready():
	add_to_group("Enemy")
	hitbox = $Area2D
	anim.play("Jittering")
	tween.connect("tween_completed", self, "onTweenCompletion")
	doTween()
	
	var _unused = connect("destroy_self", self, "OnDestruction")
	
	# Debug stuff
	if Globals.debug:
		debugPos.show()
		debugFollow.show()

func _physics_process(_delta):
	rotor.flip_h = !rotor.flip_h
	position.x = positionToFollow
	
	# Raycast para soltar la piedra
	# Obtiene informacion del espacio y colisiones
	var spaceState = get_world_2d().direct_space_state
	# Crea el raycast
	var result = spaceState.intersect_ray(position, position + Vector2(0, rayLength), [self], collision_mask)
	# Suelta la piedra si el raycast intercepta al jugador y si todavia la tiene
	if result:
		if result.collider.is_in_group("Player") and hasRock:
			DropRock()
	# Debug stuff
	debugPos.position = position
	debugFollow.position.x = positionToFollow

func InitializeTweenLegacy():
	# El tiempo que toma ir del empezar a la posicion final
	duration = endPoint.length() / float(speed * 64)
	
	# Crea el tween para que se mueva y lo empieza
	# En vez de manipular la posicion directamente, cambia "positionToFollow"
	# Start -> End
	tween.interpolate_property(self, "positionToFollow", Vector2.ZERO, endPoint, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, idleTime)
	# End -> Start
	# (note que lo unico que cambia es poner poner la posicion del empezar y el final al reves, y alargar el tiempo que dura en empezar)
	tween.interpolate_property(self, "positionToFollow", endPoint, Vector2.ZERO, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, duration + idleTime * 2)
	tween.start()
	
func doTween():
	tween.interpolate_property(self, "positionToFollow", toPoint[0], toPoint[1], duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT, idleTime)
	tween.start()
	
func onTweenCompletion(_object, _key):
	toPoint.invert()
	renderer.flip_h = !renderer.flip_h
	doTween()

# AI, tirar piedra al destruirse
func DropRockAndDestroySelf():
	if hasRock:
		DropRock()
		queue_free()

func DropRock():
	# Deja la piedra caer
	var globalPos = rock_child.global_position
	remove_child(rock_child)
	call_deferred("RemoveRockChild")
	rock_child.position = globalPos
	rock_child.Drop()
	hasRock = false

func OnDestruction():
	emit_signal("camera_shake_requested")
	
	Renderer.spawn4Piece(renderer.texture, renderer.global_position, renderer.global_rotation, renderer.global_scale, renderer.z_index)
	
	for sprite in renderer.get_children():
		if sprite is Sprite:
			Renderer.spawn4Piece(sprite.texture, sprite.global_position, sprite.global_rotation, sprite.global_scale, sprite.z_index)
			
	DropRockAndDestroySelf()

func RemoveRockChild():
	get_tree().get_root().add_child(rock_child)
