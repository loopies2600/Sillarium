extends Node

onready var mute = Settings.getSetting("audio", "mute_audio")

var currentMusic

func musicSetup(bgmID):
	if !mute:
		if (bgmID != null):
			var musicToLoad = load(Globals.LoadJSON("res://data/json/music.json", str(bgmID))["file"])
			
			if currentMusic == null:
				currentMusic = AudioStreamPlayer.new()
				currentMusic.stream = musicToLoad
				currentMusic.play()
				add_child(currentMusic)
				
			if currentMusic.stream != musicToLoad:
				currentMusic.stop()
				currentMusic.stream = load(Globals.LoadJSON("res://data/json/music.json", str(bgmID))["file"])
				currentMusic.play()
			
			if Globals.debug:
				if getMusicPeakVolume() != Vector2(-200, -200):
					Globals.debugOverlay.add_var("music peak volume (left, right)", self, "getMusicPeakVolume", true)
	
func getMusicPeakVolume():
	var left = AudioServer.get_bus_peak_volume_left_db(0, 0)
	var right = AudioServer.get_bus_peak_volume_right_db(0, 0)
	
	return Vector2(left, right)
