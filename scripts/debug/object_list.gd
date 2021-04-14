extends Panel

onready var lists := [$VBoxContainer/TabContainer/BACKGROUNDS/BGList, $VBoxContainer/TabContainer/MUSIC/MUSICList, $VBoxContainer/TabContainer/OBJECTS/OBJList, $VBoxContainer/TabContainer/PICKUPS/PICKUPList, $VBoxContainer/TabContainer/SCENES/SCENEList, $VBoxContainer/TabContainer/WEATHER/WEATHERList]

var targetJSON := [Renderer.BG, Audio.MUSIC, Objects.OBJ, Objects.PICKUP, Globals.SCENE, Renderer.WEATHER]
var targetIcons := ["res://sprites/debug/object_list/bg.png", "res://sprites/debug/object_list/music.png", "res://sprites/debug/object_list/obj.png", "res://sprites/debug/object_list/pickup.png", "res://sprites/debug/object_list/scene.png", "res://sprites/debug/object_list/weather.png"]

var holdingObject = null

func _ready():
	Objects.currentWorld = self
	
	for i in range(lists.size()):
		lists[i].connect("item_activated", self, "_on" + lists[i].name + "ItemActivated")
		
		for j in range(Globals.getJSONSize(targetJSON[i])):
			lists[i].add_item(str(Globals.getJSONEntryName(targetJSON[i], j)).to_upper(), load(targetIcons[i]))
	
func _onBGListItemActivated(index):
	Renderer.backgroundSetup(index)
	
func _onMUSICListItemActivated(index):
	Audio.musicSetup(index)
	
func _onOBJListItemActivated(index):
	Objects.spawn(index)
	
func _onPICKUPListItemActivated(index):
	if Globals.player:
		Globals.player.pickUpWeapon(index)
	
func _onSCENEListItemActivated(index):
	Globals.LoadScene(index)
	
func _onWEATHERListItemActivated(index):
	Renderer.weatherSetup(index)
