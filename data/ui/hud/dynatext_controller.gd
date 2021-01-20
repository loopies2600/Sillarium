extends CanvasLayer

var dynachar = preload("res://data/ui/hud/dynachar.tscn")
export (String) var stringu

var charPos = Vector2()
var charWidth = 64
var charHeight = 64
var line = 0

func _ready():
	_renderText()
	
func _renderText():
	
	for c in len(stringu):
		_spawnCharacter(stringu[c], "Wave1", charPos, 0.1 * c)
			
		charPos.x += charWidth
			
		if (stringu[c]) == "_":
			charPos.x = 0
			charPos.y += charHeight
	
func _unhandled_key_input(event):
	_restart()
	
func _spawnCharacter(c, anim, pos, delay):
	var newChar = dynachar.instance()
	newChar.anim = anim
	newChar.animation = c
	newChar.delay = delay
	newChar.toPos = pos
	add_child(newChar)
	
func _restart():
	for c in get_children():
		c.queue_free()
		
	charPos = Vector2()
	
	_renderText()
