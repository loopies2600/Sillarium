extends CanvasLayer

var dontShowCones := true setget _setCones

onready var anim = $Animator
onready var mask = $Mask
onready var rects = [$Rects/Parallax/Layer0/Tiles0, $Rects/Parallax/Layer1/Tiles1]

func _ready():
	var _unused = Audio.connect("pump", self, "_flip")
	
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
