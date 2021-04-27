extends Light2D

export (int) var detectionLength = 512

func _ready():
	set_as_toplevel(true)
	
func _process(_delta):
	visible = Renderer.flicker
	var spaceState = get_world_2d().direct_space_state
	var result = spaceState.intersect_ray(get_parent().global_position, get_parent().global_position + Vector2(0, detectionLength), [get_parent()], get_parent().collision_mask)
	
	if result:
		rotation = result.normal.angle()
		global_position = result.position
	else:
		visible = false
