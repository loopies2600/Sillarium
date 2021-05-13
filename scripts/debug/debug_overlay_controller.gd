extends CanvasLayer

onready var objList = $ObjectsList

var targetAlpha := 0.0
var vars = []

func _ready():
	if !OS.is_debug_build():
		queue_free()
		
	for child in get_children():
		child.modulate.a = 0.0
		
	add_var("object count", Performance, "get_monitor", true, "", 10)
	
func add_var(var_name, object, var_ref, is_method, latter_word := "", argument = null):
	vars.append([var_name, object, var_ref, is_method, latter_word, argument])

func _process(delta):
	for child in get_children():
		child.modulate.a = lerp(child.modulate.a, targetAlpha, delta * 16)
		
	if objList.modulate.a < 0.1:
		objList.hide()
	else:
		objList.show()
	
	var debug_text = "SILLARIUM VARIABLES\n"
	
	for v in vars:
		var value = null
		if v[1] and weakref(v[1]).get_ref():
			if v[3]:
				if v[5]:
					value = v[1].call(v[2], v[5])
				else:
					value = v[1].call(v[2])
			else:
				value = v[1].get(v[2])
			
		if value is Vector2:
			value = value.round()
			value.y = -value.y
		if value is float:
			value = round(value)
			
		debug_text += str(v[0], ": ", value, v[4], "\n").to_upper()
		
	$DebugInfo.text = debug_text
	
	if Globals.debugMenuOpen:
		targetAlpha = 1.0
	else:
		targetAlpha = 0.0
	
func _input(event):
	if event.is_action_pressed("toggle_debug"):
		if Globals.debug:
			Globals.debugMenuOpen = !Globals.debugMenuOpen
			
