extends Node2D

onready var Player = get_parent()
onready var targetSprite = preload("res://sprites/debug/target.png")

func _ready():
	pass
	
func _process(delta):
	update()
	
func _draw():
	if Player.target != null:
		draw_texture(targetSprite, Player.hitPos - global_position - Vector2(16, 16))
		
		if Player.target["collider"].is_in_group("Enemy"):
			draw_texture(targetSprite, Player.hitPos - global_position - Vector2(16, 16), Color(1, 0, 0, 1))
