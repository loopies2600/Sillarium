extends KinematicBody2D
class_name BasicEnemy, "res://sprites/ui/menu/enemy.png"

signal destroy_self
signal camera_shake_requested
signal freeze_frame_requested

onready var hitbox

export (int) var health = 50
export (int) var damage = 2
export (bool) var killsPlayer = true

func _ready():
	yield(get_parent(), "ready")
	hitbox.connect("area_entered", self, "OnAreaEntered")
	hitbox.connect("body_entered", self, "OnBodyEntered")
	hitbox.connect("area_exited", self, "OnAreaExited")
	hitbox.connect("body_exited", self, "OnBodyExited")

func OnAreaEntered(area):
	if area.is_in_group("PlayerProjectile"):
		area.kill()
		emit_signal("camera_shake_requested")
		emit_signal("destroy_self")

func OnBodyEntered(body):
	if body is Player and killsPlayer:
		body.takeDamage(damage)
	
func OnAreaExited(area):
	pass
	
func OnBodyExited(body):
	pass
