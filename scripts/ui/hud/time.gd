extends CanvasLayer

signal timeout

onready var anim = $Animator
onready var timlab = $Time

var minsLeft = 3 setget _setMinsLeft
var secsLeft = 0

func _ready():
	_startTimer()
	
func _startTimer():
	if minsLeft >= 0:
		timlab.text = "%02d:%02d" % [minsLeft, secsLeft]
		yield(get_tree().create_timer(1), "timeout")
		
		if !get_tree().paused:
			secsLeft -= 1
			
			if secsLeft < 0:
				self.minsLeft -= 1
				secsLeft = 59
			
		_startTimer()
	else:
		emit_signal("timeout")
		
func _setMinsLeft(value : int):
	minsLeft = value
	
	if minsLeft == 0:
		anim.play("blinkRed")
