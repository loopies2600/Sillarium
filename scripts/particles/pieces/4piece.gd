extends Node2D

var pieceNeedsToBeThisBigToRenderAShadow := Vector2(32, 32)
var flipH : bool
var flipV : bool
var shadowScale := Vector2.ONE
var texture : Texture

onready var pieces = [$Piece, $Piece2, $Piece3, $Piece4]

func _ready():
	pieces[0].initialVel = Vector2(rand_range(-128, -64), rand_range(-512, 256))
	pieces[1].initialVel = Vector2(rand_range(128, 64), rand_range(-512, 256))
	pieces[2].initialVel = Vector2(rand_range(-128, -64), rand_range(-512, 256))
	pieces[3].initialVel = Vector2(rand_range(128, 64), rand_range(-512, 256))
	
	for piece in pieces:
		piece.shadow.scale = shadowScale
		piece.velocity = piece.initialVel
		piece.sprite.flip_h = flipH
		piece.sprite.flip_v = flipV
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
	
	for piece in pieces:
		if piece.sprite.region_rect.size <= pieceNeedsToBeThisBigToRenderAShadow:
			piece.shadow.queue_free()
			
func _process(_delta):
	if get_child_count() == 0:
		queue_free()
