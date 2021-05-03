extends "../behaviour/basic_enemy_controller.gd"

onready var sprite = $Sprite
onready var animPlayer = $AnimationPlayer
onready var collisionBox = $CollisionShape2D

export (PackedScene) var particle

func _ready():
	hitbox = $Area2D
	var _unused = connect("destroyed", self, "OnDestruction")
	animPlayer.play("Swinging")
	
func disableCollision():
	collisionBox.disabled = true

func OnDestruction():
	call_deferred("disableCollision")
	emit_signal("camera_shake_requested")
	Renderer.spawn4Piece(sprite)
	animPlayer.play("Exploding")

func EmitParticles():
	var newParticles = particle.instance()
	newParticles.emitting = true
	get_tree().get_root().add_child(newParticles)
	newParticles.global_position = global_position
