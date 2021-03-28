extends CanvasLayer

var papaSlot = "player"
var papa = Globals.get(papaSlot)

onready var anim = $Animator
onready var bg = $Container/Background

onready var livlab = $Container/Stuff/HealthStuff/Lives
onready var hplab = $Container/Stuff/HealthStuff/HP
onready var scolab = $Container/Stuff/ScoringStuff/Score
onready var wpslab = $Container/Stuff/ScoringStuff/Weapon
onready var comlab = $Container/Stuff/ComboStuff/Counter

func _ready():
	Objects.connect("player_back_in_action", self, "_setupVars")
	
	if papa:
		_setupVars()
	
func _connectStuff():
	papa = Globals.get(papaSlot)
	for property in ["health", "lives", "score", "weapon", "combo"]:
		papa.connect("player_" + property + "_updated", self, "_setupVars")
		
func _setupVars(_health = "don't use this variable!"):
	_connectStuff()
	
	papa = Globals.get(papaSlot)
	var curData = Data._data[papaSlot]
	
	if papa:
		comlab.text = str(papa.combo)
		hplab.text = "HEALTH = " + str(papa.health)
	
	livlab.text = "LIVES = " + str(curData.lives)
	scolab.text = "SCORE = " + str(curData.total_score)
	wpslab.text = "WEAPON = " + Objects.getWeaponName(curData.weapon)
	
func _process(_delta):
	bg.flip_v = !bg.flip_v
	
func _fadeStart(mode):
	if mode == "in":
		anim.play("SweepUp")
