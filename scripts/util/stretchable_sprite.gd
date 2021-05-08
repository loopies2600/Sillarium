extends Line2D

var startPos := Vector2(0, 0) setget _sPos
var endPos := Vector2(128, 0) setget _ePos

export (Texture) var sprite setget _spRite
var texMode := 2 setget _stMode

func _ready():
	texture = sprite
	width = sprite.get_size().y
	texture_mode = texMode
	
	points[0] = startPos
	points[1] = endPos
	
func _sPos(value : Vector2):
	startPos = value
	points[0] = startPos
	
func _ePos(value : Vector2):
	endPos = value
	points[1] = endPos
	
func _spRite(value : Texture):
	sprite = value
	texture = sprite
	width = sprite.get_size().x
	
func _stMode(value : int):
	texMode = value
	texture_mode = texMode
