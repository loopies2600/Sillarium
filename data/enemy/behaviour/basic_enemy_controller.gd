extends KinematicBody2D
class_name BasicEnemy, "res://sprites/ui/menu/enemy.png"

signal camera_shake_requested(mode, time, amp)
signal destroy_self
signal take_damage

onready var hitbox

export (int) var health = 5
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
		_takeDamage(area.damage)

func OnBodyEntered(body):
	if body is Player and killsPlayer:
		body.takeDamage(damage)
	
func _takeDamage(damage : int):
	health -= damage
	
	if health <= 0:
		emit_signal("destroy_self")
	else:
		emit_signal("take_damage")
		
func OnAreaExited(area):
	pass
	
func OnBodyExited(body):
	pass
