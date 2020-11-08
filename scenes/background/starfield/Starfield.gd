extends CanvasLayer

onready var star = preload("res://scenes/background/starfield/Star.tscn")
onready var maxStars = 512

enum modes {LEFT, RIGHT, FORWARDS, BACKWARDS}

var stars = []
var screenWidth = OS.get_screen_size().x
var screenHeight = OS.get_screen_size().y
var mode = modes.LEFT

func _ready():
	for n in range(maxStars):
		randomize()
		spawnStar(n)

func spawnStar(index):
	var randomizedScale = rand_range(0.5, 0.75)
	
	stars.append(star.instance())
	stars[index].movementMode = mode
	stars[index].startPos = Vector2(randi() % int(screenWidth), randi() % int(screenHeight))
	stars[index].limit = Vector2(screenWidth, screenHeight)
	stars[index].wind = rand_range(4, 8)
	stars[index].scale = Vector2(randomizedScale, randomizedScale)
	stars[index].modulate.a = randomizedScale
	add_child(stars[index])
