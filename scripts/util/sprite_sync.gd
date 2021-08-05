extends Sprite

var target

func _process(_delta):
	region_enabled = target.region_enabled
	region_rect = target.region_rect
	flip_h = target.flip_h
	flip_v = target.flip_v
	position = target.position
	rotation = target.rotation
	scale = target.scale
	texture = target.texture
