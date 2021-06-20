extends StaticBody2D

export (float) var weight = 0.1

var texture
var targetY

func _ready():
	$Sprite.texture = texture
	$CollisionBox.shape.radius = texture.get_width() / 2
	
func _process(_delta):
	position.y = lerp(position.y, targetY, weight)
