extends Light2D

onready var updateRate = $UpdateRate

func _ready():
	set_as_toplevel(true)
	
func _physics_process(_delta):
	var spaceState = get_world_2d().direct_space_state
	var result = spaceState.intersect_ray(get_parent().global_position, get_parent().global_position + Vector2(0, 512), [get_parent()], get_parent().collision_mask)
	
	if result:
		rotation = result.normal.angle()
		global_position = result.position
