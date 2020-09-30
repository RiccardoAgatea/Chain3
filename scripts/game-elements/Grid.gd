extends Node2D

# Dimensions (in slots) of the grid
export (int) var width
export (int) var height

# Piece types
onready var tile_types := load_tiles()

# Grid holding the pieces
var grid := []

# State control
var user_active := true


func _ready():
	randomize()


func load_tiles() -> Array:
	var file := File.new()
	file.open("res://config/tiles.json", File.READ)
	return JSON.parse(file.get_as_text()).result()


func load_grid(layout: Array):
	for row in layout:
		grid.append([])
		for cell in row:
			var c := Cell.new(info)
			grid[i].append(c)
			add_child(c)

			if cell.tile:
				var info = tile_types[randi() % tile_types.size()]
				c.make_tile(info)
