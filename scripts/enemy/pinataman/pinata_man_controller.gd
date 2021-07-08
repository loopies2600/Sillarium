extends "../behaviour/basic_enemy_controller.gd"

export (PackedScene) var particle

func _ready():
	var _unused = connect("destroyed", self, "OnDestruction")
	animator.play("Swinging")
	
func disableCollision():
	collisionBox.disabled = true

func OnDestruction():
	call_deferred("disableCollision")
	emit_signal("camera_shake_requested")
	animator.play("Exploding")

func EmitParticles():
	var newParticles = particle.instance()
	newParticles.emitting = true
	get_tree().get_root().add_child(newParticles)
	newParticles.global_position = global_position
	Renderer.spawn4Piece(mainSprite)
