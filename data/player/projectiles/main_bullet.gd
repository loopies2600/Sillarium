extends Area2D

onready var sprite = $Sprite
onready var dust = preload("res://data/player/projectiles/dust.tscn")

export (int) var damage = 5
export (Vector2) var speed = Vector2(1500, 0)

var color = Color.lightyellow
var velocity = Vector2()
var spn = 0

func _ready():
	velocity = speed.rotated(rotation)
	var _unused = connect("body_entered", self, "_bodyEnter")
	_unused = connect("area_entered", self, "_areaEnter")
	_unused = $VisibilityNotifier2D.connect("screen_exited", self, "OnScreenExited")
	
func _physics_process(delta):
	Renderer.spawnTrail(0.2, sprite)
	position += velocity * delta

func _bodyEnter(_body):
	kill()
	
func _areaEnter(_area):
	kill()

func OnScreenExited():
	queue_free()
	
func kill():
	var newDust = dust.instance()
	get_tree().get_root().add_child(newDust)
	newDust.modulate = color
	newDust.position = position
	queue_free()
