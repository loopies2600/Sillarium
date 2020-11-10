extends Node2D

export (int) var bgSpeed = 1
onready var box = $Box
onready var tail = $Tail
onready var text = $Text
onready var tguy = $Owner

var elapsedTime = 0
var textSpeed = 0.03
var skipAnim = false
var messages = ["Hola", "Como estas", "Yo bien", "Y vos?", "WOOOOOOO SI SIRVEEEEE KKKKKKKKKKKKKK"]
var page = 0

func _process(delta):
	elapsedTime += delta
	
	text.text = messages[page]
	
	if !skipAnim:
		text.set_visible_characters(elapsedTime / textSpeed)
	else:
		text.set_visible_characters(text.text.length())
		
	doFancyTextBoxStuff(0.1, tguy.texture.get_size().x / 2)
	
	if Input.is_action_just_pressed("jump"):
		if text.visible_characters < text.text.length():
			skipAnim = true
		else:
			changePage()
	
func doFancyTextBoxStuff(drag, tailOffset):
	tail.visible = !tail.visible
	box.visible = !box.visible
	tguy.position = get_global_mouse_position()
	tail.position.x = lerp(tail.position.x, tguy.position.x, drag)
	tail.polygon[2].x = tguy.position.x - tail.position.x
	tail.polygon[2].y = tguy.position.y + (tailOffset)
	box.texture_offset.y = fmod(box.texture_offset.y + bgSpeed, box.texture.get_size().y)
	tail.texture_offset.y = box.texture_offset.y

func changePage():
	skipAnim = false
	elapsedTime = 0
	
	if page < messages.size() -1:
		page += 1
	else:
		page = 0
