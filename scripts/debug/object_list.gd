extends Panel

onready var lists := [$VBoxContainer/TabContainer/BACKGROUNDS/BGList, $VBoxContainer/TabContainer/MUSIC/MUSICList, $VBoxContainer/TabContainer/OBJECTS/OBJList, $VBoxContainer/TabContainer/PICKUPS/PICKUPList, $VBoxContainer/TabContainer/SCENES/SCENEList, $VBoxContainer/TabContainer/WEATHER/WEATHERList]

var targetJSON := [Renderer.BG, Audio.MUSIC, Objects.OBJ, Objects.PICKUP, Globals.SCENE, Renderer.WEATHER]
var targetIcons := ["res://sprites/debug/object_list/bg.png", "res://sprites/debug/object_list/music.png", "res://sprites/debug/object_list/obj.png", "res://sprites/debug/object_list/pickup.png", "res://sprites/debug/object_list/scene.png", "res://sprites/debug/object_list/weather.png"]

var holdingObject = null

func _ready():
	for i in range(lists.size()):
		lists[i].connect("item_activated", self, "_on" + lists[i].name + "ItemActivated")
		
		for j in range(Globals.getJSONSize(targetJSON[i])):
			lists[i].add_item(str(Globals.getJSONEntryName(targetJSON[i], j)).to_upper(), load(targetIcons[i]))
	
func _onBGListItemActivated(index):
	var sameBG = Renderer.backgroundSetup(index)
	
	if sameBG:
		print("background index ", index, " is already in use. background wont change!")
	else:
		print("background index ", index, " loaded...")
	
func _onMUSICListItemActivated(index):
	var isPlaying = Audio.musicSetup(index)
	
	if isPlaying:
		print("music index ", index, " is already playing. music wont change!")
	else:
		print("music index ", index, " starts playing...")
	
func _onOBJListItemActivated(index):
	Objects.spawn(index)
	
func _onPICKUPListItemActivated(index):
	if Globals.player:
		Globals.player.pickUpWeapon(index)
	
func _onSCENEListItemActivated(index):
	var wereHere = Globals.LoadScene(index)
	
	if wereHere:
		print("we're already on scene index ", index, ", what are you trying to do?")
	else:
		print("going to scene index ", index, "...")
	
func _onWEATHERListItemActivated(index):
	var sameWeather = Renderer.weatherSetup(index)
	
	if sameWeather:
		print("weather index ", index, " is already in use. weather wont change!")
	else:
		print("weather index ", index, " loaded...")
