""" este singleton contiene cosas referentes a los graficos
	no te dejes intimidar por su nombre, no da tantitos problemas editarlo """

extends Node

# otra variable que lee desde la configuración, esta es para decidir si deberiamos dibujar los fondos o no
onready var backgrounds = Settings.getSetting("renderer", "display_backgrounds")
onready var fullscreen = Settings.getSetting("renderer", "fullscreen")
onready var frameFreezer = Settings.getSetting("renderer", "freeze_frame")

# estas dos variables se usan para guardar tanto la transición como el fondo actual.
var transition
var currentBackground

func _ready():
	toggleFS()
	
func toggleFS():
	fullscreen = Settings.getSetting("renderer", "fullscreen")
	OS.window_fullscreen = fullscreen
	
func spawnTrail(fds, tex, pos, rot, scl, z = 0):
	# algunos sprites van a dejar un rastro, así que esta función se encarga de spawnear ese rastro.
	# los argumentos son en orden: tiempo de desvanecimiento, textura, posición, rotación, escala, y orden Z.
	var newTrail = Objects.getObj(7)
	newTrail.fadeSpeed = fds
	newTrail.texture = tex
	newTrail.global_position = pos
	newTrail.global_rotation = rot
	newTrail.global_scale = scl
	newTrail.z_index = z
	Objects.currentWorld.add_child(newTrail)
	
func fade(mode = "in", mask = preload("res://sprites/debug/radius.png")):
	# esta función se encarga de spawnear la transición, solo si no hay ninguna transición actualmente.
	# los argumentos son: modo ("in" o "out") y mascara.
	if transition == null:
		var newFade = Objects.getObj(20)
		transition = newFade
		newFade.mode = mode
		newFade.mask = mask
		Objects.currentWorld.add_child(newFade)
	
func backgroundSetup(bgID):
	backgrounds = Settings.getSetting("renderer", "display_backgrounds")
	# esta función se encarga de cargar y spawnear un fondo desde el JSON, solo si no hay ningun fondo actualmente. en caso contrario, lo reemplaza.
	if backgrounds:
		if (bgID != null):
			var backgroundToLoad = load(Globals.LoadJSON("res://data/json/backgrounds.json", bgID)["file"])
			
			if currentBackground == null:
				var background = backgroundToLoad
				currentBackground = background.instance()
				Objects.currentWorld.add_child(currentBackground)
			else:
				currentBackground.queue_free()
				
			if currentBackground != backgroundToLoad:
				currentBackground.queue_free()
				var background = backgroundToLoad
				currentBackground = background.instance()
				Objects.currentWorld.add_child(currentBackground)
	else:
		if currentBackground != null:
			currentBackground.queue_free()
			
			
func freezeFrame(delay : int):
	if not frameFreezer:
		return
	OS.delay_msec(delay)
