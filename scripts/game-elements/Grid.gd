extends Node2D

# Dimensions (in slots) of the grid
export (int) var width
export (int) var height

# Scenes
const CELL := preload("res://scenes/game-elements/Cell.tscn")

# Piece types
onready var tile_types := load_tiles()

# Grid holding the pieces
var cell_size: int
var grid := []

# State control
var user_active := true

# selected cells
var selected_cells := []


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
				var info = tile_types[randi() % tile_types.size()]
				if not c.make_tile(info):
					pass

		grid.append(r)


func pos_to_pixels(r: int, c: int) -> Vector2:
	var x: int = round((cell_size / 2.0) + c * (cell_size as float)) as int
	var y: int = round((cell_size / 2.0) + r * (cell_size as float)) as int
	return Vector2(x, y)


func pixels_to_pos(coordinates: Vector2) -> Vector2:
	var r: int = ((coordinates.y as float) / (cell_size as float)) as int
	var c: int = ((coordinates.x as float) / (cell_size as float)) as int
	return Vector2(r, c)


func click(coordinates: Vector2):
	var pos := pixels_to_pos(coordinates)
	var r: int = pos.x as int
	var c: int = pos.y as int

	if r < 0 or r >= height or c < 0 or c >= width:
		return

	(grid[r][c] as Cell).select()
