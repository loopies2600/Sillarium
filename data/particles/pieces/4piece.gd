extends Node2D

var texture : Texture

onready var pieces = [$Piece, $Piece2, $Piece3, $Piece4]

func _ready():
	for piece in pieces:
		piece.sprite.texture = texture
		piece.hitbox.rotation -= global_rotation
		
	var pieceSize = pieces[0].sprite.texture.get_size() / 2
	
	pieces[0].position = Vector2(-pieceSize.x / 2, -pieceSize.y / 2)
	pieces[1].position = Vector2(pieceSize.x / 2, -pieceSize.y / 2)
	pieces[2].position = Vector2(-pieceSize.x / 2, pieceSize.y / 2)
	pieces[3].position = Vector2(pieceSize.x / 2, pieceSize.y / 2)
	
	pieces[0].sprite.region_rect = Rect2(0.0, 0.0, pieceSize.x, pieceSize.y)
	pieces[1].sprite.region_rect = Rect2(pieceSize.x, 0.0, pieceSize.x, pieceSize.y)
	pieces[2].sprite.region_rect = Rect2(0.0, pieceSize.y, pieceSize.x, pieceSize.y)
	pieces[3].sprite.region_rect = Rect2(pieceSize.x, pieceSize.y, pieceSize.x, pieceSize.y)
