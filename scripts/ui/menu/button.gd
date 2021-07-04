extends Button

var speed := 32
var selectedButton = null
var buttonID := 0
var moveTowards := false
var targetPos := Vector2()

func _ready():
	var _unused = connect("pressed", self, "buttonPress")
	_unused = connect("mouse_entered", self, "onMouseEnter")
	_unused = connect("mouse_exited", self, "onMouseExit")
	
func _process(delta):
	if moveTowards:
		rect_position = lerp(rect_position, targetPos, speed * delta)
		
func buttonPress():
	pass
	
func onMouseEnter():
	if !disabled:
		Audio.playSound(8)
	
func onMouseExit():
	selectedButton = null
