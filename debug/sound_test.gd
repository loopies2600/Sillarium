extends Camera2D

onready var musicPlayer = preload("res://streams/music_player.tscn")
onready var label = $Details/Info

var text
export (int) var ID = 0

func _ready():
	_backgroundSetup()
	_musicSetup()
	
	text = "Background: " + _getName("background") + "\nMusic: " + _getName("music")
	
func _process(delta):
	label.text = text.to_upper()
	
func _backgroundSetup():
	var background = load(Globals.LoadJSON("res://data/json/backgrounds.json", ID)["file"])
	var newBackground = background.instance()
	add_child(newBackground)
		
func _musicSetup():
	var music = musicPlayer.instance()
	music.stream = load(Globals.LoadJSON("res://data/json/music.json", ID)["file"])
	music.play()
	add_child(music)
	
func _getName(obj):
	match obj:
		"background":
			return Globals.LoadJSON("res://data/json/backgrounds.json", ID)["name"]
		"music":
			return Globals.LoadJSON("res://data/json/music.json", ID)["name"]
