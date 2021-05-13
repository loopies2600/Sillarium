extends ParallaxLayer

export (int) var scrollSpeed = 64
export (Vector2) var scrollFactor = Vector2(1, 1)

onready var screenRes := Vector2(get_viewport().get_visible_rect().size.x, get_viewport().get_visible_rect().size.y)

func _physics_process(delta):
	motion_offset.x = int(motion_offset.x + ((scrollSpeed * delta) * scrollFactor.x)) % int(screenRes.x)
	motion_offset.y = int(motion_offset.y + ((scrollSpeed * delta) * scrollFactor.y)) % int(screenRes.y)
