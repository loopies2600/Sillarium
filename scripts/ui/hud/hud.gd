extends CanvasLayer

signal timeout

var firstConnection := true
var papaSlot = "player"
var papa = Globals.get(papaSlot)
var minsLeft = 3 setget _setMinsLeft
var secsLeft = 0

onready var anim = $Animator
onready var bg = $Container/Background

onready var livlab = $Container/Stuff/HealthStuff/Lives
onready var hplab = $Container/Stuff/HealthStuff/HP
onready var scolab = $Container/Stuff/ScoringStuff/Score
onready var wpslab = $Container/Stuff/ScoringStuff/Weapon
onready var amolab = $Container/Stuff/Ammo
onready var comlab = $Container/Stuff/ComboStuff/Counter
onready var timlab = $Time

func _ready():
	var _unused = Objects.connect("player_back_in_action", self, "_setupVars")
	
	if papa:
		_setupVars()
		
	_startTimer()
	
func _startTimer():
	if minsLeft >= 0:
		timlab.text = "%02d:%02d" % [minsLeft, secsLeft]
		yield(get_tree().create_timer(1), "timeout")
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
		anim.play("blinkTimer")
		
func _connectStuff():
	if !firstConnection:
		_disconnectStuff()
		
	papa = Globals.get(papaSlot)
	for property in ["health", "lives", "score", "weapon", "combo"]:
		papa.connect("player_" + property + "_updated", self, "_setupVars")
		
	papa.weapon.connect("weapon_ammo_updated", self, "_setupVars")
	
	firstConnection = false
		
func _disconnectStuff():
	papa = Globals.get(papaSlot)
	for property in ["health", "lives", "score", "weapon", "combo"]:
		papa.disconnect("player_" + property + "_updated", self, "_setupVars")
		
	papa.weapon.disconnect("weapon_ammo_updated", self, "_setupVars")
	
func _setupVars(_health = "don't use this variable!"):
	_connectStuff()
	
	papa = Globals.get(papaSlot)
	var curData = Data._data[papaSlot]
	
	if papa:
		comlab.text = str(papa.combo)
		hplab.text = "HEALTH= " + str(papa.health)
	
	livlab.text = "LIVES= " + str(curData.lives)
	scolab.text = "SCORE= " + str(curData.total_score)
	wpslab.text = "WEAPON= " + Globals.getJSONEntryName(Objects.PICKUP, curData.weapon).to_upper()
	amolab.text = "AMMO= " + str(papa.weapon.ammo)
	
func _process(_delta):
	bg.flip_v = Renderer.flicker
	
func _fadeStart(mode):
	if mode == "in":
		anim.play("SweepUp")
