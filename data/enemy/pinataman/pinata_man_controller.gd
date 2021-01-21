extends "../basic_enemy_controller.gd"

onready var animPlayer = $AnimationPlayer
onready var hitbox = $CollisionShape2D

export (PackedScene) var particle

var velocity = Vector2()

func _ready():
	var _unused = connect("DestroySelf", self, "OnDestruction")
	animPlayer.play("Swinging")
	
func DisableHitbox():
	hitbox.disabled = true

func OnDestruction():
	call_deferred("DisableHitbox")
	animPlayer.play("Exploding")

func EmitParticles():
	var newParticles = particle.instance()
	newParticles.emitting = true
	get_tree().get_root().add_child(newParticles)
	newParticles.global_position = global_position
