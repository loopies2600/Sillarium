extends Area2D

onready var detector = $EntityDetector
onready var segment = preload("res://data/objects/bridge_segment.tscn")

export (float) var multiplier = 2.0
export (int) var segmentAmount = 22
export (Texture) var segmentTexture

var currentSegment
var entityStood
var segments := []

func _ready():
	var _unused = connect("body_entered", self, "_entityEnter")
	_unused = connect("body_exited", self, "_entityExit")
	
	for i in range(segmentAmount):
		segments.append(segment.instance())
		segments[i].position.x += segmentTexture.get_width() * i
		segments[i].texture = segmentTexture
		add_child(segments[i])
		
	detector.shape.extents.x = (segmentTexture.get_width() / 2) * segmentAmount
	detector.position.x = (segmentTexture.get_width() / 2) * (segmentAmount - 1)
	detector.position.y = -segmentTexture.get_height() * 1.5
	
func _physics_process(_delta):
	var maxDepression
	
	if entityStood:
		currentSegment = floor((entityStood.global_position.x - global_position.x) / segmentTexture.get_width()) + 1
	else:
		currentSegment = 0
		
	if currentSegment <= segmentAmount / 2:
		maxDepression = currentSegment * 2
	else:
		maxDepression = ((segmentAmount - currentSegment) + 1) * 2
	
	for i in range(segmentAmount):
		var difference = abs((i + 1) - currentSegment)
		var segmentDistance
		
		if i < currentSegment:
			segmentDistance = 1 - (difference / currentSegment)
		else:
			segmentDistance = 1 - (difference / ((segmentAmount - currentSegment) + 1))
			
		segments[i].targetY = floor(maxDepression * sin(deg2rad(90 * segmentDistance))) * multiplier
	
func _entityEnter(body):
	if entityStood:
		return
		
	entityStood = body
	
func _entityExit(_body):
	if !entityStood:
		return
		
	entityStood = null
