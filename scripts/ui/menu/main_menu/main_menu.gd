extends CanvasLayer

export (int) var backgroundID = 0
export (int) var musicID = 0

onready var anim = $Animator
onready var buttons = [$Buttons/Play, $Buttons/Options, $Buttons/Exit]
onready var pak = $PressAnyKey

var activePrompt := false
var danced := false
var targetScene = 0

var tick := 0 setget _setTick

func _ready():
	if activePrompt:
		Renderer.backgroundSetup(backgroundID,  {"dontShowCones" : false})
		
		for button in buttons:
			button.disabled = true
			button.hide()
	else:
		Renderer.backgroundSetup(backgroundID, {"dontShowCones" : true})
		pak.queue_free()
		
	Renderer.fade("out")
	Audio.musicSetup(musicID)
	
	for button in buttons:
		button.connect("mouse_entered", self, "_onButtonMouseEnter")
		button.connect("pressed", self, "_on" + button.name + "Pressed")
	
func _input(event):
	if activePrompt:
		if event is InputEventKey:
			Renderer.backgroundSetup(backgroundID, {"dontShowCones" : true})
			pak.queue_free()
			
			for button in buttons:
				button.disabled = false
				button.show()
				
			activePrompt = false
		
func _process(_delta):
	self.tick = Audio.customTick(30.0)
	
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
		
func _setTick(value):
	if value == tick:
		return
	else:
		if danced:
			anim.play("DanceLeft")
		else:
			anim.play("DanceRight")
			
		danced = !danced
		
		tick = value
