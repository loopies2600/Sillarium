extends Kinematos
class_name BasicEnemy, "res://sprites/ui/menu/enemy.png"

# warning-ignore:unused_signal
signal destroyed
signal took_damage

export (NodePath) var nHitbox

export (int) var health = 5
export (int) var damage = 2
export (int) var score = 50
export (bool) var killsPlayer = true

onready var hitbox = get_node(nHitbox)

func _ready():
	yield(get_parent(), "ready")
	var _unused = hitbox.connect("area_entered", self, "onAreaEntered")
	_unused = hitbox.connect("body_entered", self, "onBodyEntered")
	_unused = hitbox.connect("area_exited", self, "onAreaExited")
	_unused = hitbox.connect("body_exited", self, "onBodyExited")
	
func onAreaEntered(area):
	if area.is_in_group("PlayerProjectile"):
		var projectile = area.get_parent()
		_takeDamage(projectile.damage, projectile.papa)
		
func onBodyEntered(body):
	if body is Player and killsPlayer:
		body.takeDamage(damage)
	
func _takeDamage(eDamage : int, dealer = null):
	health -= eDamage
	
	if health <= 0:
		dealer.score += score
		dealer.combo += score
		emit_signal("destroyed")
	else:
		emit_signal("took_damage")
		
func onAreaExited(_area):
	pass
	
func onBodyExited(_body):
	pass
