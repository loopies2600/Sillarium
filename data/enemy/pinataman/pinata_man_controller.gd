extends "../behaviour/basic_enemy_controller.gd"

onready var sprite = $Sprite
onready var animPlayer = $AnimationPlayer
onready var collisionBox = $CollisionShape2D

export (PackedScene) var particle

var velocity = Vector2()

func _ready():
	hitbox = $Area2D
	var _unused = connect("destroy_self", self, "OnDestruction")
	animPlayer.play("Swinging")
	
func disableCollision():
	collisionBox.disabled = true

func OnDestruction():
	emit_signal("camera_shake_requested")
	call_deferred("disableCollision")
	Renderer.spawn4Piece(sprite.texture, sprite.global_position, sprite.global_rotation, sprite.global_scale, sprite.z_index)
	animPlayer.play("Exploding")

func EmitParticles():
	var newParticles = particle.instance()
	newParticles.emitting = true
	get_tree().get_root().add_child(newParticles)
	newParticles.global_position = global_position
