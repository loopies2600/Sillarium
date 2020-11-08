extends CanvasLayer

var vars = []

func add_var(var_name, object, var_ref, is_method, latter_word:String = ""):
	vars.append([var_name, object, var_ref, is_method, latter_word])

func _process(delta):
	var debug_text = "SILLARIUM DEBUG INFO\n"
	
	for v in vars:
		var value = null
		
		if v[1] and weakref(v[1]).get_ref():
			if v[3]:
				value = v[1].call(v[2])
			else:
				value = v[1].get(v[2])
		debug_text += str(v[0], ": ", value, v[4], "\n").to_upper()
		
	$DebugInfo.text = debug_text
	
	if Input.is_action_just_pressed("toggle_debug"):
		$DebugInfo.visible = !$DebugInfo.visible
