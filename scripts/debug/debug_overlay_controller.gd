extends CanvasLayer

var targetAlpha := 0.0
var vars = []

func _ready():
	add_var("music peak volume (left, right)", Audio, "getMusicPeakVolume", true)
	add_var("player 1 position (X, Y)", Globals.player, "global_position", false)
	add_var("player 2 position (X, Y)", Globals.playerTwo, "global_position", false)
	add_var("object count", get_tree().get_root(), "get_child_count", true)
	
func add_var(var_name, object, var_ref, is_method, latter_word:String = ""):
	vars.append([var_name, object, var_ref, is_method, latter_word])

func _process(delta):
	for child in get_children():
		child.modulate.a = lerp(child.modulate.a, targetAlpha, delta * 16)
	
	var system_text = "SYSTEM VARIABLES\n"
	var debug_text = "SILLARIUM VARIABLES\n"
	
	for v in vars:
		var value = null
		
		if v[1] and weakref(v[1]).get_ref():
			if v[3]:
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
	var video = OS.get_current_video_driver()
	system_text += str("video mode: ", _getVideoDriverName(video), "\n").to_upper()
	
	$SystemInfo.text = system_text
	
func _input(event):
	if event.is_action_pressed("toggle_debug"):
		Globals.debugMenuOpen = !Globals.debugMenuOpen
		
		if Globals.debugMenuOpen:
			targetAlpha = 1.0
		else:
			targetAlpha = 0.0
			
func _getVideoDriverName(id : int) -> String:
	match id:
		0:
			return "GLES3"
		1:
			return "GLES2"
			
	return "UNKNOWN"
