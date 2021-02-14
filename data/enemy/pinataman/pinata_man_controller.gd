extends "../behaviour/basic_enemy_controller.gd"

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
	call_deferred("disableCollision")
	animPlayer.play("Exploding")

func EmitParticles():
	var newParticles = particle.instance()
	newParticles.emitting = true
	get_tree().get_root().add_child(newParticles)
	newParticles.global_position = global_position
