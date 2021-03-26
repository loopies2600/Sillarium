extends RichTextLabel

export(float) var soundBitVolume = 1.0
export(String) var soundBitBus = "Sound"

var texts := []
var sounds := []
var textSpeed := 0.75
var printing := false
var currentPage := 0
var charCount := 0

onready var soundBitPlayer: AudioStreamPlayer = AudioStreamPlayer.new()
onready var charTimer : Timer = Timer.new()

func _ready():
	soundBitPlayer.volume_db = soundBitVolume
	soundBitPlayer.bus = soundBitBus
	add_child(soundBitPlayer)
	
	add_child(charTimer)
	charTimer.set_one_shot(true)
	charTimer.connect("timeout", self, "_addChar")
	
func _process(_delta):
	visible_characters = charCount
	
func _input(event):
	if event.is_action_pressed("jump"):
		if charCount < texts[currentPage].length():
			charCount = texts[currentPage].length()
			printing = false
		else:
			_movePage(1)
			
func _movePage(howMany : int):
	if currentPage < texts.size() - 1:
		currentPage += howMany
	else:
		currentPage = 0
	
	charCount = 0
	printing = true
	text = texts[currentPage]
	_startTimer()
	
func _message(strings := [], soundList := [], speed := textSpeed):
	sounds = soundList
	
	for msg in len(strings):
		strings[msg] = strings[msg].to_upper()
		
	texts = strings
	textSpeed = speed
	printing = true
	
	text = texts[currentPage]
	_startTimer()
	
func _startTimer(waitTime := textSpeed):
	charTimer.set_wait_time(waitTime)
	charTimer.start()
	
func _addChar():
	if printing:
		charCount += 1
		
		if charCount > texts[currentPage].length() - 1:
			printing = false
			
		if sounds:
			if texts[currentPage][charCount - 1] != " ":
				_playSoundBit(sounds)
				_startTimer()
			else:
				_startTimer(textSpeed * 1.25)
		
func _playSoundBit(sndArray := []):
	soundBitPlayer.stream = load(sndArray[randi() % sndArray.size()])
	soundBitPlayer.pitch_scale = rand_range(0.75, 1.25)
	soundBitPlayer.play()
