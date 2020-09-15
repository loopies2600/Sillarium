extends Node2D

onready var Player = get_parent()
onready var targetSprite = preload("res://sprites/debug/target.png")

func _ready():
	pass # Replace with function body.
	
func _process(delta):
	update()
	
func _draw():
	if Player.target:
		draw_texture(targetSprite, Player.hitPos - global_position - Vector2(16, 16))
