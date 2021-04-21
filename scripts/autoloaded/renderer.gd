""" este singleton contiene cosas referentes a los graficos
	no te dejes intimidar por su nombre, no da tantitos problemas editarlo """

extends Node

const BG = "res://data/json/backgrounds.json"
const WEATHER = "res://data/json/climates.json"
const SCREENSHOTS_PATH = "user://screenshots/"

# otra variable que lee desde la configuración, esta es para decidir si deberiamos dibujar los fondos o no
onready var climates = Settings.getSetting("renderer", "display_weather")
onready var backgrounds = Settings.getSetting("renderer", "display_backgrounds")
onready var fullscreen = Settings.getSetting("renderer", "fullscreen")
onready var frameFreezer = Settings.getSetting("renderer", "freeze_frame")

# estas dos variables se usan para guardar tanto la transición como el fondo actual.
var transition
var currentBackground
var currentWeather

# esta variable guarda la textura de la pantalla, ojo con no actualizarla todo el tiempo!
var curViewportTex

func _ready():
	toggleFS()
	
func _input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		Settings.setSetting("renderer", "fullscreen", !fullscreen)
		Settings.saveSettings()
		toggleFS()
		
	if event.is_action_pressed("take_screenshot"):
		takeScreenshot()
		
func toggleFS():
	fullscreen = Settings.getSetting("renderer", "fullscreen")
	OS.window_fullscreen = fullscreen
	
func spawnTrail(fds : float, sprite : Sprite, mdt := Color.white):
	# algunos sprites van a dejar un rastro, así que esta función se encarga de spawnear ese rastro.
	# los argumentos son en orden: tiempo de desvanecimiento, textura, posición, rotación, escala, y orden Z.
	var newTrail = Objects.getObj(7)
	newTrail.modulation = mdt
	newTrail.fadeSpeed = fds
	newTrail.texture = sprite.texture
	newTrail.global_position = sprite.global_position
	newTrail.global_rotation = sprite.global_rotation
	newTrail.global_scale = sprite.global_scale
	newTrail.z_index = sprite.z_index - 1
	newTrail.flip_h = sprite.flip_h
	newTrail.flip_v = sprite.flip_v
	newTrail.offset = sprite.offset
	Objects.currentWorld.add_child(newTrail)
	
func spawn4Piece(sprite : Sprite):
	# basado en el codigo del fade, se nota
	var fourPiece = Objects.getObj(23)
	fourPiece.texture = sprite.texture
	fourPiece.global_position = sprite.global_position
	fourPiece.global_rotation = sprite.global_rotation
	fourPiece.global_scale = sprite.scale
	fourPiece.z_index = sprite.z_index
	fourPiece.flipH = sprite.flip_h
	fourPiece.flipV = sprite.flip_v
		
	Objects.currentWorld.call_deferred("add_child", fourPiece)
	
func fade(mode := "in", mask = preload("res://sprites/debug/test_transition.png"), viewportFX := true):
	# esta función se encarga de spawnear la transición, solo si no hay ninguna transición actualmente.
	# los argumentos son: modo ("in" o "out") y mascara.
	if transition == null:
		if viewportFX:
			var newFade = Objects.getObj(26)
			transition = newFade
			newFade.mode = mode
			
			if mode == "in":
				curViewportTex = _generateScreenshot()
				
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
		
func weatherSetup(weatherID):
	climates = Settings.getSetting("renderer", "display_weather")
	
	if climates:
		if (weatherID != null):
			var weatherToLoad = Globals.LoadJSON(WEATHER, weatherID, "file")
			var weather = load(weatherToLoad).instance()
			
			if !currentWeather:
				currentWeather = weather
				add_child(currentWeather)
				return false
				
			if currentWeather.filename == weatherToLoad:
				return true
			else:
				currentWeather.queue_free()
				currentWeather = weather
				add_child(currentWeather)
				return false
	else:
		if currentWeather != null:
			currentWeather.queue_free()
			currentWeather = null
			
func backgroundSetup(bgID):
	backgrounds = Settings.getSetting("renderer", "display_backgrounds")
	# esta función se encarga de cargar y spawnear un fondo desde el JSON, solo si no hay ningun fondo actualmente. en caso contrario, lo reemplaza.
	if backgrounds:
		if (bgID != null):
			var backgroundToLoad = Globals.LoadJSON(BG, bgID, "file")
			var background = load(backgroundToLoad).instance()
			
			if !currentBackground:
				currentBackground = background
				add_child(currentBackground)
				return false
				
			if currentBackground.filename == backgroundToLoad:
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
			
func _generateScreenshot(path := SCREENSHOTS_PATH) -> Texture:
	var tempImage = Image.new()
	tempImage = get_viewport().get_texture().get_data()
	tempImage.flip_y()
	var tempTexture = ImageTexture.new()
	tempTexture.create_from_image(tempImage)
	
	if Globals.debug:
		var vvpDir = Directory.new()
		if !vvpDir.dir_exists(path):
			vvpDir.make_dir_recursive(path)
		
		var vvpNumber = str(Data.getFileList(path, ["screenshot_"]).size())
		var vvpName = "viewport_" + vvpNumber + ".png"
		tempImage.save_png(path + vvpName)
		
	return tempTexture
	
func takeScreenshot(path := SCREENSHOTS_PATH):
	var tempImage = Image.new()
	tempImage = get_viewport().get_texture().get_data()
	tempImage.flip_y()
	
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
