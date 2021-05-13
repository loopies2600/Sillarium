extends Kinematos
class_name Projectile

onready var particles = Settings.getSetting("renderer", "particles")

export (int) var damage = 5
export (bool) var hasGravity = false
export (float) var initialJump = 0
export (Vector2) var speed = Vector2(750, 0)

onready var boundaries : CollisionShape2D
onready var hitbox : Area2D
onready var sprite : Sprite

var color = Color.white
var papa

func initialize():
	var visibility = VisibilityNotifier2D.new()
	visibility.connect("screen_exited", self, "kill")
	
	var _unused = hitbox.connect("area_entered", self, "onAreaEntered")
	_unused = hitbox.connect("body_entered", self, "onBodyEntered")
	_unused = hitbox.connect("area_exited", self, "onAreaExited")
	_unused = hitbox.connect("body_exited", self, "onBodyExited")
	
	# warning-ignore:integer_division
	# warning-ignore:integer_division
	# por qué esto es una alerta? no es como si rompiera el juego o algo...
	boundaries.shape.extents = Vector2(sprite.texture.get_width() / 2, sprite.texture.get_height() / 2)
	visibility.rect = Rect2(boundaries.shape.extents.x / -2, boundaries.shape.extents.y / -2, boundaries.shape.extents.x * 2, boundaries.shape.extents.y * 2)
	
	setupSpeed()
	
func setupSpeed():
	velocity = speed.rotated(rotation)
	velocity.y -= initialJump
	
func doGravity(_delta):
	if hasGravity:
		velocity.y += Globals.GRAVITY
	
func onAreaEntered(_area):
	kill()
	
func onBodyEntered(_body):
	kill()
	
func onAreaExited(_area):
	pass
	
func onBodyExited(_body):
	pass
	
func kill():
	_spawnDust()
	queue_free()
	
func _spawnDust(dustPath = "res://data/player/projectiles/dust.tscn"):
	if particles:
		var dust = load(dustPath).instance()
		dust.modulate = color
		dust.position = position
		get_tree().get_current_scene().add_child(dust)
