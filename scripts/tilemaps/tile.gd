extends TileMap

func _draw():
	if Globals.debugMenuOpen:
		var size = get_viewport_rect().size * Globals.player.camera.zoom
		var follow = Globals.player.position
		for i in range(int((follow.x - size.x) / Globals.CELL_SIZE.x) - 1, int((size.x + follow.x) / Globals.CELL_SIZE.x) + 1):
			draw_line(Vector2(i * Globals.CELL_SIZE.x, follow.y + size.y + 100), Vector2(i * Globals.CELL_SIZE.x, follow.y - size.y - 100), Color.red, 2)
		for i in range(int((follow.y - size.y) / Globals.CELL_SIZE.y) - 1, int((size.y + follow.y) / Globals.CELL_SIZE.y) + 1):
			draw_line(Vector2(follow.x + size.x + 100, i * Globals.CELL_SIZE.y), Vector2(follow.x - size.x - 100, i * Globals.CELL_SIZE.y), Color.red, 2)

func _process(_delta):
	update()
