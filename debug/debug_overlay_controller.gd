extends CanvasLayer

var vars = []

func add_var(var_name, object, var_ref, is_method, latter_word:String = ""):
	vars.append([var_name, object, var_ref, is_method, latter_word])

func _process(delta):
	var system_text = "SYSTEM VARIABLES\n"
	var debug_text = "SILLARIUM VARIABLES\n"
	
	for v in vars:
		var value = null
		
		if v[1] and weakref(v[1]).get_ref():
			if v[3]:
				value = v[1].call(v[2])
			else:
				value = v[1].get(v[2])
		debug_text += str(v[0], ": ", value, v[4], "\n").to_upper()
		
	$DebugInfo.text = debug_text
	
	#FPS
	var fps = Engine.get_frames_per_second()
	system_text += str("framerate: ", fps, " fps\n").to_upper()
	
	#memoria dinamica utilizada
	var dmem = OS.get_dynamic_memory_usage()
	system_text += str("dynamic memory: ", String.humanize_size(dmem), "\n").to_upper()
	
	#memoria estatica utilizada
	var smem = OS.get_static_memory_usage()
	system_text += str("static memory: ", String.humanize_size(smem), "\n").to_upper()
	
	#driver de video
	var video = OS.get_video_driver_name(0)
	system_text += str("video mode: ", video, "\n").to_upper()
	
	$SystemInfo.text = system_text
	
	if Input.is_action_just_pressed("toggle_debug"):
		$DebugInfo.visible = !$DebugInfo.visible
		$SystemInfo.visible = !$SystemInfo.visible
