extends CanvasLayer

var dynachar = preload("res://data/ui/hud/dynachar.tscn")
export (String) var stringu

var charPos = Vector2()
var xPadding = 64
var yPadding = 64

func _ready():
	_renderText()
	
func _renderText():
	
	for c in len(stringu):
		_spawnCharacter(stringu[c], "Jump", charPos, 0.1 * c)
			
		charPos.x += xPadding
			
		if (stringu[c]) == "_":
			charPos.x = 0
			charPos.y += yPadding
	
func _unhandled_key_input(_event):
	_restart()
	
func _spawnCharacter(c, anim, pos, delay):
	var newChar = dynachar.instance()
	newChar.anim = anim
	newChar.animation = c
	newChar.delay = delay
	newChar.position = pos
	add_child(newChar)
	
func _restart():
	for c in get_children():
		c.queue_free()
		
	charPos = Vector2()
	
	_renderText()
