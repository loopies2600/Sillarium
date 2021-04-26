extends CanvasLayer

export (int) var backgroundID = 0
export (int) var musicID = 0

onready var anim = $Animator
onready var buttons = [$Menu/Buttons/Play, $Menu/Buttons/Options, $Menu/Buttons/Exit]
onready var buildNumber = $Build

var danced := false
var targetScene = 0

func _init():
	Objects.currentWorld = self
	
func _ready():
	Renderer.fade("out")
	randomize()
	buildNumber.text = "SILLARIUM BUILD " + str(randi() % 32768)
	Renderer.backgroundSetup(backgroundID,  {"dontShowCones" : true})
	var _unused = Audio.connect("pump", self, "_onBeat")
	Audio.musicSetup(musicID)
	
	for button in buttons:
		button.connect("mouse_entered", self, "_onButtonMouseEnter")
		button.connect("pressed", self, "_on" + button.name + "Pressed")
	
func _onButtonMouseEnter():
	for button in buttons:
		if !button.disabled:
			Audio.playSound(8)
	
func _onPlayPressed():
	_prepareScene(3)
	
func _onOptionsPressed():
	_prepareScene(2)
	
func _onExitPressed():
	_prepareScene(null)
	
func _prepareScene(index):
	for button in buttons:
		button.disabled = true
		
	targetScene = index
	var snd = Audio.playSound(6)
	
	yield(snd, "finished")
	Renderer.fade("in")
	Renderer.transition.connect("fade_finished", self, "_fadeEnd")
	
func _fadeEnd(_mode):
	if targetScene:
		Globals.LoadScene(targetScene)
	else:
		get_tree().quit()
		
func _onBeat(_beatNo):
	if danced:
		anim.play("DanceLeft")
	else:
		anim.play("DanceRight")
		
	danced = !danced
