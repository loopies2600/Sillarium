extends Node2D

export (int) var bgSpeed = 1
onready var box = $Box
onready var tail = $Tail
onready var text = $Text
onready var tguy = $Owner

func _ready():
	text.print_message("SERA QUE SE PUEDA HACER BUEN TEXTO?", 0.1)
	
func _process(delta):
	doFancyTextBoxStuff(0.1, tguy.texture.get_size().x / 2)
	
func doFancyTextBoxStuff(drag, tailOffset):
	tail.visible = !tail.visible
	box.visible = !box.visible
	tguy.position = get_global_mouse_position()
	tail.position.x = lerp(tail.position.x, tguy.position.x, drag)
	tail.polygon[2].x = tguy.position.x - tail.position.x
	tail.polygon[2].y = tguy.position.y + (tailOffset)
	box.texture_offset.y = fmod(box.texture_offset.y + bgSpeed, box.texture.get_size().y)
	tail.texture_offset.y = box.texture_offset.y
