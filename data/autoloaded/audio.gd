""" ESTE SINGLETON SE ENCARGA DE MANEJAR TODO LO REFERENTE AL AUDIO! 
   ACORDATE DE QUE SIEMPRE DEBE ESTAR CARGADO Y ACTIVADO YA QUE ESTE REPRODUCTOR SE USA GLOBALMENTE """

extends Node

# lee desde el archivo de configuración si el juego deberia reproducir musica.
onready var mute = Settings.getSetting("audio", "mute_audio")

# esta variable guarda el reproductor de audio que se este usando, ojo, no es para guardar el archivo actual que se este reproduciendo
var currentMusic

func musicSetup(bgmID):
	# ! significa "NO", o sea que si mute esta desactivado, todo este pedazo de codigo se va a ejecutar.
	if !mute:
		# si bgmID tiene algun numero dentro...
		if (bgmID != null):
			# se va a cargar el archivo de musica desde el JSON, según su ID.
			var musicToLoad = load(Globals.LoadJSON("res://data/json/music.json", str(bgmID))["file"])
			
			# si no existe un reproductor de audio, creemos uno y que reproduzca la musica que le pasamos arriba.
			if currentMusic == null:
				currentMusic = AudioStreamPlayer.new()
				currentMusic.stream = musicToLoad
				currentMusic.play()
				add_child(currentMusic)
				
			# si el reproductor existe, pero queremos cambiar de musica, paramos la musica anterior y empezamos a reproducir la nueva.
			if currentMusic.stream != musicToLoad:
				currentMusic.stop()
				currentMusic.stream = load(Globals.LoadJSON("res://data/json/music.json", str(bgmID))["file"])
				currentMusic.play()
			
			# si el modo debug esta activado, registremos el volumen en la interfaz debug.
			if Globals.debug:
				if getMusicPeakVolume() != Vector2(-200, -200):
					Globals.debugOverlay.add_var("music peak volume (left, right)", self, "getMusicPeakVolume", true)
	
func getMusicBPM(bgmID):
	# el tempo de la musica es un valor que se lee desde el JSON. necesitamos pasarle el ID del tema el cual queremos conseguir su tempo.
	var tempo = Globals.LoadJSON("res://data/json/music.json", str(bgmID))["tempo"]
	
	return float(tempo)
	
func getMusicPeakVolume():
	# el volumen de cada lado del parlante del servidor de audio, se lo pasamos con un Vector2 para manipularlo más fácil.
	var left = AudioServer.get_bus_peak_volume_left_db(0, 0)
	var right = AudioServer.get_bus_peak_volume_right_db(0, 0)
	
	return Vector2(left, right)
