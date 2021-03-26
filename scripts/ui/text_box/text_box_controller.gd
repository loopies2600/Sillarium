extends Node2D

export (int) var bgSpeed = 1
onready var box = $Box
onready var tail = $Tail
onready var text = $Text
onready var tguy = $Owner

func _ready():
	message(["lol, hola!!!!!!!!", "este texto se separa por comas", "en plan; asi [uno, dos, tres]", "se llega a alargar demasiado la lista, pero vemos que hacemos!!!!!", "estoy muy emocionado por poder probar esto en acción..."],
	 ["res://streams/sfx/unknown_voice.wav", "res://streams/sfx/player/asb_fire.wav"], 
	0.05)
	
func message(strings := [], soundList := [], speed := 0.25):
	text._message(strings, soundList, speed)
	
func _process(delta):
	doFancyTextBoxStuff(0.1, tguy.texture.get_size().y / 2)
	
func doFancyTextBoxStuff(drag, tailOffset):
	var smallOffset = (tail.position.x - get_viewport_rect().size.x / 2) * -0.125
	tail.position.x = lerp(tail.position.x, tguy.position.x, drag) + (smallOffset * 0.25)
	tail.polygon[2].x = tguy.position.x - tail.position.x + smallOffset
	tail.polygon[2].y = tguy.position.y - tailOffset
	box.texture_offset.y = fmod(box.texture_offset.y + bgSpeed, box.texture.get_size().y)
	tail.texture_offset.y = box.texture_offset.y
