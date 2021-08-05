extends Node2D

onready var papa = get_parent()

export (int) var detectionLength = 512
export (Vector2) var positionOffset = Vector2(-24, 8)
export (Vector2) var shearing = Vector2(0.25, -0.125)
export (int) var angleOffset = 90

onready var shadows = Settings.getSetting("renderer", "shadows")

func _ready():
	transform.y = shearing
	
	if !shadows:
		queue_free()
		
	set_as_toplevel(true)
	
func _process(_delta):
	var spaceState = get_world_2d().direct_space_state
	var result = spaceState.intersect_ray(papa.global_position, papa.global_position + Vector2(0, detectionLength), [papa], papa.collision_mask)
	
	if result:
		visible = true
		transform.origin = result.position + positionOffset
	else:
		visible = false
