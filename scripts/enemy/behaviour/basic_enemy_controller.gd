extends KinematicBody2D
class_name BasicEnemy, "res://sprites/ui/menu/enemy.png"

# warning-ignore:unused_signal
signal camera_shake_requested(mode, time, amp)
signal destroy_self
signal take_damage

onready var hitbox : Area2D

export (int) var health = 5
export (int) var damage = 2
export (int) var score = 50
export (bool) var killsPlayer = true

func _ready():
	yield(get_parent(), "ready")
	var _unused = hitbox.connect("area_entered", self, "onAreaEntered")
	_unused = hitbox.connect("body_entered", self, "onBodyEntered")
	_unused = hitbox.connect("area_exited", self, "onAreaExited")
	_unused = hitbox.connect("body_exited", self, "onBodyExited")

func onAreaEntered(area):
	if area.is_in_group("PlayerProjectile"):
		_takeDamage(area.damage, area.papa)

func onBodyEntered(body):
	if body is Player and killsPlayer:
		body.takeDamage(damage)
	
func _takeDamage(eDamage : int, dealer = null):
	health -= eDamage
	
	if health <= 0:
		dealer.score += score
		dealer.combo += score
		emit_signal("destroy_self")
	else:
		emit_signal("take_damage")
		
# warning-ignore:unused_argument
func onAreaExited(area):
	pass
	
# warning-ignore:unused_argument
func onBodyExited(body):
	pass
