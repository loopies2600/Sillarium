extends Camera2D

onready var musicPlayer = preload("res://streams/music_player.tscn")
onready var label = $Details/Info

var text
export (int) var ID = 0

func _ready():
	Objects.currentWorld = self
	Renderer.fade("out")
	Renderer.backgroundSetup(ID)
	Audio.musicSetup(ID)
	
	text = "Background: " + _getName("background") + "\nMusic: " + _getName("music")
	
func _process(_delta):
	label.text = text.to_upper()
	
func _getName(obj):
	match obj:
		"background":
			return Globals.LoadJSON("res://data/json/backgrounds.json", ID, "name")
		"music":
			return Globals.LoadJSON("res://data/json/music.json", ID, "name")
