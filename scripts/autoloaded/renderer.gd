""" este singleton contiene cosas referentes a los graficos
	no te dejes intimidar por su nombre, no da tantitos problemas editarlo """

extends Node

const FLICKER_RATE := 0.025

const BG = "res://data/database/backgrounds/"
const WEATHER = "res://data/database/climates/"
const SCREENSHOTS_PATH = "user://screenshots/"

# otra variable que lee desde la configuración, esta es para decidir si deberiamos dibujar los fondos o no
onready var backgrounds = Settings.getSetting("renderer", "display_backgrounds")
onready var climates = Settings.getSetting("renderer", "display_weather")
onready var directRendering = Settings.getSetting("renderer", "direct_rendering")
onready var fullscreen = Settings.getSetting("renderer", "fullscreen")
onready var frameFreezer = Settings.getSetting("renderer", "freeze_frame")
onready var vsync = Settings.getSetting("renderer", "vsync")

# estas dos variables se usan para guardar tanto la transición como el fondo actual.
var transition
var currentBackground
var currentWeather

# esta variable guarda la textura de la pantalla, ojo con no actualizarla todo el tiempo!
var curViewportTex
var flicker := false

func _ready():
	toggleFS()
	toggleVSync()
	
	_flicker()
	
func _flicker():
	flicker = !flicker
	yield(get_tree().create_timer(FLICKER_RATE), "timeout")
	_flicker()
	
func _input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		toggleFS()
		
	if event.is_action_pressed("take_screenshot"):
		takeScreenshot()
	
func toggleDirectRendering():
	directRendering = Settings.getSetting("renderer", "direct_rendering")
	VisualServer.viewport_set_render_direct_to_screen(get_viewport().get_viewport_rid(), directRendering)
	
func toggleFS():
	fullscreen = Settings.getSetting("renderer", "fullscreen")
	OS.set_window_fullscreen(fullscreen)
	
func toggleVSync():
	vsync = Settings.getSetting("renderer", "vsync")
	OS.set_use_vsync(vsync)
	
func spawnTrail(fadeSpeed : float, sprite : Sprite, modulation = Color.white):
	var newTrail = Objects.getObj(7)
	
	newTrail.fadeSpeed = fadeSpeed
	
	if modulation is String:
		newTrail.randomColors = true
	else:
		newTrail.modulation = modulation
	
	for p in ["texture", "global_position", "global_rotation", "global_scale", "z_index", "flip_h", "flip_v", "offset"]:
		newTrail.set(p, sprite.get(p))
		
	get_tree().get_current_scene().add_child(newTrail)
	
func fade(mode := "in", mask = preload("res://sprites/debug/test_transition.png"), viewportFX := false):
	# esta función se encarga de spawnear la transición, solo si no hay ninguna transición actualmente.
	# los argumentos son: modo ("in" o "out") y mascara.
	if transition == null:
		if viewportFX:
			var newFade = Objects.getObj(26)
			transition = newFade
			newFade.mode = mode
			
			if mode == "in":
				var tempImage = _generateScreenshot()
				
				var tempTexture = ImageTexture.new()
				tempTexture.create_from_image(tempImage)
				
				curViewportTex = tempTexture
				
			newFade.tex = curViewportTex
				
			get_tree().get_root().call_deferred("add_child", newFade)
		else:
			var newFade = Objects.getObj(20)
			transition = newFade
			newFade.mode = mode
			newFade.mask = mask
			get_tree().get_root().call_deferred("add_child", newFade)
		
	for transitionFunc in get_tree().get_nodes_in_group("TransitionFunc"):
		transition.connect("fade_started", transitionFunc, "_fadeStart")
		transition.connect("fade_finished", transitionFunc, "_fadeEnd")
		
func weatherSetup(weatherID, cVars := {}, subWeather := 0):
	climates = Settings.getSetting("renderer", "display_weather")
	
	if climates:
		var resource = load(WEATHER + "%s.tres" % weatherID)
		
		if (weatherID != null):
			var weatherToLoad = resource.scenes[subWeather]
			var weather = weatherToLoad.instance()
			
			if !currentWeather:
				currentWeather = weather
				add_child(currentWeather)
				Objects.setupCustomVars(currentWeather, cVars)
				return false
			else:
				Objects.setupCustomVars(currentWeather, cVars)
				
			if currentWeather.filename == weatherToLoad.get_path():
				Objects.setupCustomVars(currentWeather, cVars)
				return true
			else:
				currentWeather.queue_free()
				currentWeather = weather
				add_child(currentWeather)
				Objects.setupCustomVars(currentWeather, cVars)
				return false
	else:
		if currentWeather != null:
			currentWeather.queue_free()
			currentWeather = null
			
func backgroundSetup(bgID, cVars := {}, subBG := 0):
	backgrounds = Settings.getSetting("renderer", "display_backgrounds")
	# esta función se encarga de cargar y spawnear un fondo desde el JSON, solo si no hay ningun fondo actualmente. en caso contrario, lo reemplaza.
	if backgrounds:
		var resource = load(BG + "%s.tres" % bgID)
		
		if (bgID != null):
			var backgroundToLoad = resource.scenes[subBG]
			var background = backgroundToLoad.instance()
			
			if !currentBackground:
				currentBackground = background
				add_child(currentBackground)
				Objects.setupCustomVars(currentBackground, cVars)
				return false
			else:
				Objects.setupCustomVars(currentBackground, cVars)
				
			if currentBackground.filename == backgroundToLoad.get_path():
				Objects.setupCustomVars(currentBackground, cVars)
				return true
			else:
				currentBackground.queue_free()
				currentBackground = background
				add_child(currentBackground)
				return false
	else:
		if currentBackground != null:
			currentBackground.queue_free()
			currentBackground = null
			
func _generateScreenshot() -> Image:
	var tempImage = Image.new()
	tempImage = get_viewport().get_texture().get_data()
	tempImage.flip_y()
	
	return tempImage
	
func takeScreenshot(path := SCREENSHOTS_PATH):
	var tempImage = _generateScreenshot()
	
	var scrDir = Directory.new()
	if !scrDir.dir_exists(path):
		scrDir.make_dir_recursive(path)
		
	var scrNumber = str(Data.getFileList(path, ["viewport_"]).size())
	var scrName = "screenshot_" + scrNumber + ".png"
	tempImage.save_png(path + scrName)
	
	print("'", scrName, "' saved!")
	
func freezeFrame(delay : int):
	if not frameFreezer:
		return
	OS.delay_msec(delay)
	
func generateShadows(node):
	var nodes = Objects.getAllNodes(node)
	var sprites := []
	
	for n in nodes:
		if n is Sprite:
			sprites.append(n)
			
	return sprites
