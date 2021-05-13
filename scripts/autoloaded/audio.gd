""" ESTE SINGLETON SE ENCARGA DE MANEJAR TODO LO REFERENTE AL AUDIO! 
   ACORDATE DE QUE SIEMPRE DEBE ESTAR CARGADO Y ACTIVADO YA QUE ESTE REPRODUCTOR SE USA GLOBALMENTE """

extends Node

signal pump(beat)

enum {MUSIC_STARTED_PLAYING, MUSIC_ALREADY_PLAYING}

const MUSIC = "res://data/database/music.json"
const SOUND = "res://data/database/sounds.json"
const COMPENSATE_FRAMES = 2
const COMPENSATE_HZ = 60.0
const WAV_PADDING = 128 # en bytes

# lee desde el archivo de configuración si el juego deberia reproducir musica y el volumen.
onready var mute = Settings.getSetting("audio", "mute_audio")
onready var masterVolume = Settings.getSetting("dont-autogenerate-buttons", "master_volume")
onready var musicVolume = Settings.getSetting("dont-autogenerate-buttons", "music_volume")
onready var soundVolume = Settings.getSetting("dont-autogenerate-buttons", "sound_volume")

# esta variable guarda el reproductor de audio que se este usando, ojo, no es para guardar el archivo actual que se este reproduciendo
var currentMusic : AudioStreamPlayer
var currentID
var currentBPM
var beat setget setBeat, getBeat
var time

func playSound(sfxID, emitter = self, volume := 1.0, pitch := 1.0):
	var soundPlayer = AudioStreamPlayer.new()
	
	soundPlayer.set_bus("Sound")
	soundPlayer.volume_db = linear2db(volume)
	soundPlayer.pitch_scale = pitch
	soundPlayer.stream = Loader.getWAV(sfxID)
	soundPlayer.connect("ready", soundPlayer, "play")
	soundPlayer.connect("finished", soundPlayer, "queue_free")
	
	emitter.add_child(soundPlayer)
	return soundPlayer
	
func musicSetup(bgmID):
	mute = Settings.getSetting("audio", "mute_audio")
	# ! significa "NO", o sea que si mute esta desactivado, todo este pedazo de codigo se va a ejecutar.
	if !mute:
		for b in AudioServer.bus_count:
			var bName := AudioServer.get_bus_name(b)
			setupVolume(bName)
		# si bgmID tiene algun numero dentro...
		if (bgmID != null):
			# se va a cargar el archivo de musica desde el JSON, según su ID.
			var musicToLoad = Loader.getOGG(bgmID)
			
			if currentID != bgmID:
				_setupMusicPlayer(bgmID, musicToLoad)
				return MUSIC_STARTED_PLAYING
			else:
				return MUSIC_ALREADY_PLAYING
			
	else:
		if currentMusic != null:
			set_process(false)
			currentMusic.queue_free()
			currentMusic = null
func stop():
	if currentMusic.playing:
		currentMusic.stop()
		currentID = null
		
func _setupMusicPlayer(bgmID, stream):
	if !currentMusic:
		currentMusic = AudioStreamPlayer.new()
		add_child(currentMusic)
		
	if bgmID != currentID:
		currentMusic.stop()
		currentMusic.stream = stream
		currentMusic.play()
		currentMusic.set_bus("Music")
		currentID = bgmID
		currentBPM = getMusicBPM(currentID)
	
func _process(_delta):
	if !currentMusic or !currentMusic.playing:
		return
	
	time = currentMusic.get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency() + (1 / COMPENSATE_HZ) * COMPENSATE_FRAMES
	self.beat = int(time * currentBPM / 60.0)
	
func setBeat(value):
	var oldBeat = beat
	
	if value == oldBeat:
		return
	else:
		beat = value
		emit_signal("pump", beat)
	
func getBeat():
	return beat
	
func getMusicBPM(bgmID):
	# el tempo de la musica es un valor que se lee desde el JSON. necesitamos pasarle el ID del tema el cual queremos conseguir su tempo.
	var tempo = Globals.LoadJSON(MUSIC, bgmID, "tempo")
	
	return float(tempo)
		
func setupVolume(bus : String):
	set(bus.to_lower() + "Volume", Settings.getSetting("dont-autogenerate-buttons", bus.to_lower() + "_volume"))
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus), linear2db(get(bus.to_lower() + "Volume")))
