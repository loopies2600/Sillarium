extends CanvasLayer

var dontShowCones := true setget _setCones

onready var anim = $Animator
onready var mask = $Mask
onready var rects = [$Tiles0, $Tiles1]
onready var flipTimer = $FlipTimer

func _ready():
	var _unused = Audio.connect("pump", self, "_flip")
	
func _process(_delta):
	rects[0].visible = Renderer.flicker
	rects[1].visible = !Renderer.flicker
		
func _flip(_beatNo):
	for rect in rects:
		rect.flip_h = !rect.flip_h
		
func _setCones(booly : bool):
	if dontShowCones != booly:
		dontShowCones = booly
		_setupAnim()
	
func _setupAnim():
	if dontShowCones:
		anim.play("out")
	else:
		anim.play("in")
