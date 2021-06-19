extends Sprite

export (Array, Resource) var definitions
export (float) var weight = 0.5

var curDefinition = 0

func _process(_delta):
	position = lerp(position, definitions[curDefinition].position, weight)
	rotation_degrees = lerp(rotation_degrees, definitions[curDefinition].rotation_degrees, weight)
	scale = lerp(scale, definitions[curDefinition].scale, weight)
