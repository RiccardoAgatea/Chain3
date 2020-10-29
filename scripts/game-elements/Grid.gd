extends Node2D

# Dimensions (in slots) of the grid
var width: int = 0
var height: int = 0

# Scenes
const CELL := preload("res://scenes/game-elements/Cell.tscn")

# Piece types
onready var tile_types := load_tiles()

# Grid holding the pieces
var cell_size: int
var grid := []

# Cells used to create new tiles at the top
var generators := []

# State control
var user_active := true

# selected cells
var selected_cells := []
signal complete_chain(chain)


func _ready():
	randomize()


func load_tiles() -> Array:
	var file := File.new()
	if file.open("res://config/tiles.json", File.READ) != OK:
		print("nou tiles")
	return JSON.parse(file.get_as_text()).result


func load_level(level_file: String):
	var file := File.new()
	if file.open(level_file, File.READ) != OK:
		print("nou level")
	var level: Dictionary = JSON.parse(file.get_as_text()).result
	height = level.rows as int
	width = level.columns as int
	cell_size = level.cellSize as int
	load_grid(level.grid)


func load_grid(layout: Array):
	for j in width:
		var c := CELL.instance()
		generators.append(c)
		add_child(c)

		c.set_grid_position(-1, j)
		c.position = pos_to_pixels(-1, j)

	for i in height:
		var row: Array = layout[i]
		var r := []
		for j in width:
			var cell: Dictionary = row[j]
			var c := CELL.instance()
			r.append(c)
			add_child(c)

			c.set_grid_position(i, j)
			c.position = pos_to_pixels(i, j)

			if cell.tile:
				generate_tile(c)
			else:
				c.set_enabled(false)

		grid.append(r)


func generate_tile(cell: Cell) -> bool:
	var info = tile_types[randi() % tile_types.size()]
	var x = cell.make_tile(info)
	return x


func pos_to_pixels(r: int, c: int) -> Vector2:
	var x: int = floor((cell_size / 2.0) + c * (cell_size as float)) as int
	var y: int = floor((cell_size / 2.0) + r * (cell_size as float)) as int
	return Vector2(x, y)


func pixels_to_pos(coordinates: Vector2) -> Vector2:
	var r: int = floor((coordinates.y as float) / (cell_size as float)) as int
	var c: int = floor((coordinates.x as float) / (cell_size as float)) as int
	return Vector2(r, c)


func click(coordinates: Vector2):
	var pos := pixels_to_pos(coordinates)
	var r: int = pos.x as int
	var c: int = pos.y as int

	if r < 0 or r >= height or c < 0 or c >= width:
		return

	if selected_cells == []:
		select(r, c)
	elif selected_cells.back().row == r and selected_cells.back().column == c:
		confirm_selection()
	elif selected_cells.has(grid[r][c]):
		while not (selected_cells.back().row == r and selected_cells.back().column == c):
			selected_cells.back().deselect()
			selected_cells.pop_back()
	elif selected_cells.back().compatible(grid[r][c]):
		select(r, c)
	else:
		deselect_all()


func select(i: int, j: int):
	var cell: Cell = grid[i][j]
	selected_cells.append(cell)
	cell.select()


func deselect_all():
	for cell in selected_cells:
		cell.deselect()

	selected_cells = []


func confirm_selection():
	var tile_list := []
	for cell in selected_cells:
		tile_list.append(cell.pop())

	selected_cells = []
	emit_signal("complete_chain", tile_list)


func refill():
	for j in width:
		for i in range(height - 1, -1, -1):
			var cell: Cell = grid[i][j]
			if cell.empty() && cell.can_accept_tile():
				for k in range(i - 1, -1, -1):
					var c: Cell = grid[k][j]
					if not c.empty():
						cell.acquire_tile(c.take_tile())
						break
				if cell.empty():
					var gen: Cell = generators[j]
					generate_tile(gen)
					var tile = gen.take_tile()
					cell.acquire_tile(tile)
