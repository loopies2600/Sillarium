extends Light2D

onready var papa = get_parent()

export (int) var detectionLength = 512

onready var shadows = Settings.getSetting("renderer", "shadows")

func _ready():
	if !shadows:
		queue_free()
		
	set_as_toplevel(true)
	
func _process(_delta):
	var spaceState = get_world_2d().direct_space_state
	var result = spaceState.intersect_ray(papa.global_position, get_parent().global_position + Vector2(0, detectionLength), [papa], papa.collision_mask)
	
	if result:
		visible = true
		rotation = result.normal.angle()
		global_position = result.position
	else:
		visible = false
