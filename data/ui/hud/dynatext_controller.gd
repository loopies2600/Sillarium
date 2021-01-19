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
		_spawnCharacter(_charToFrame(stringu[c]), charPos, "Test", 0.1 * c)
			
		charPos.x += charWidth
			
		if (stringu[c]) == "_":
			charPos.x = 0
			charPos.y += charHeight
	
func _unhandled_key_input(event):
	_restart()
	
func _charToFrame(c):
	match c:
		"A":
			return 0
		"B":
			return 1
		"C":
			return 2
		"D":
			return 3
		"E":
			return 4
		"F":
			return 5
		"G":
			return 6
		"H":
			return 7
		"I":
			return 8
		"J":
			return 9
		"K":
			return 10
		"L":
			return 11
		"M":
			return 12
		"N":
			return 13
		"O":
			return 14
		"P":
			return 15
		"Q":
			return 16
		"R":
			return 17
		"S":
			return 18
		"T":
			return 19
		"U":
			return 20
		"V":
			return 21
		"W":
			return 22
		"X":
			return 23
		"Y":
			return 24
		"Z":
			return 25
		"!":
			return 26
		"?":
			return 27
		" ":
			return 28
		"_":
			return 28
			print("making a new line..")
			
func _spawnCharacter(c, pos, anim, delay):
	var newChar = dynachar.instance()
	newChar.anim = anim
	newChar.character = c
	newChar.delay = delay
	newChar.toPos = pos
	add_child(newChar)
	
func _restart():
	for c in get_children():
		c.queue_free()
		
	charPos = Vector2()
	
	_renderText()
