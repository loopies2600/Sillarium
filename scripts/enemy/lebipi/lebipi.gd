extends "../behaviour/basic_enemy_controller.gd"

onready var anim = $Graphics/AnimationPlayer
onready var rock = $LebipiRock
onready var renderer = $Graphics/Body
onready var rotor = $Graphics/Body/Rotor
onready var collisionBox = $Hitbox
onready var visibility = $Visibility

export (float) var idleTime = 0.5
export (float) var accel = 32
export (float) var damping = 0.975
export (int, -1, 1) var direction = 1
export (float) var separation = 256
export (float) var separationRandomness = 64
export (float) var speed = 386
export (float) var speedRandomness = 64
export (float) var steerStrength = 128

var detectionLength = 512
var hasRock = true
var onScreen = false
var target = null

func _ready():
	speed += rand_range(-speedRandomness, speedRandomness)
	separation += rand_range(-separationRandomness, separationRandomness)
	
	for s in ["entered", "exited"]:
		var _unused = visibility.connect("screen_" + s, self, "_screen" + s)
		
	var _unused = connect("destroy_self", self, "_onDestruction")
	
	placeOutOfScreen(direction)
	hitbox = $Area2D
	anim.play("Jittering")
	
func _screenentered():
	onScreen = true
	
func _screenexited():
	onScreen = false
	
func _onLevelInit():
	target = Globals.player
	
func raycastPlayer():
	var spaceState = get_world_2d().direct_space_state
	var result = spaceState.intersect_ray(position, position + Vector2(0, detectionLength), [self], collision_mask)
	
	if result:
		if result.collider.is_in_group("Player") and hasRock:
			return true
			
	return false
		
func _process(_delta):
	rotor.flip_h = !rotor.flip_h
	
func _physics_process(_delta):
	velocity = move_and_slide(velocity)
	
func seek():
	var steer = Vector2.ZERO
	
	if target:
		var processedPos = target.position + Vector2(0, -separation)
		var desired = (processedPos - position).normalized() * speed
		steer = (desired - velocity).normalized() * steerStrength
		
	return steer
	
func _dropRockAndDestroySelf():
	if hasRock:
		dropRock()
		
	queue_free()

func dropRock():
	# Deja la piedra caer
	var globalPos = rock.global_position
	remove_child(rock)
	call_deferred("_removeRock")
	rock.position = globalPos
	rock.Drop()
	hasRock = false

func _onDestruction():
	emit_signal("camera_shake_requested")
	
	Renderer.spawn4Piece(renderer)
	
	for sprite in renderer.get_children():
		if sprite is Sprite:
			Renderer.spawn4Piece(sprite)
			
	_dropRockAndDestroySelf()

func _removeRock():
	get_tree().get_root().add_child(rock)

