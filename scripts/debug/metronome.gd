extends ColorRect

var BPM = 80

onready var anim = $Animator
onready var click = $Click
onready var beatTimer = $BeatTimer
onready var bpmLabel = $BPMLabel

func _ready():
	_beat()
	beatTimer.connect("timeout", self, "_onBeat")
	
func _process(delta):
	if BPM > 60:
		if Input.is_action_pressed("aim_left"):
			BPM -= 1
			_beat(true)
	if Input.is_action_pressed("aim_right"):
		BPM += 1
		_beat(true)
		
	bpmLabel.text = "BPM: " + str(BPM)
	
func _beat(onlyChangeBPM = false):
	if !onlyChangeBPM:
		click.stop()
		click.pitch_scale = rand_range(0.75, 1.25)
		click.play()
			
		anim.stop(true)
		anim.play("Click")
	beatTimer.wait_time = Engine.get_frames_per_second() / BPM
	
func _onBeat():
	_beat()
