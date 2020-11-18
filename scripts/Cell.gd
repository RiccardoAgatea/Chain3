extends Node2D

class_name Cell

# Position
var row: int
var column: int

# Layers
var back: BackTile  #back
var tile: Tile = null  #sprite
var effect: FrontTile  #front

# Empty cells
var enabled: bool = true

# Tile scene
const TILE := preload("res://scenes/Tile.tscn")


func _ready():
	back = $BackTile
	effect = $FrontTile


func set_enabled(en: bool):
	enabled = en


func make_tile(info: Dictionary) -> bool:
	if not empty():
		return false

	var t := TILE.instance()
	t.init(info)
	t.position = global_position
	return acquire_tile(t)


func take_tile() -> Tile:
	if not empty():
		remove_child(tile)
		tile.position = to_global(tile.position)

	var t := tile
	tile = null
	return t


func acquire_tile(t: Tile) -> bool:
	if can_accept_tile():
		tile = t
		add_child_below_node(back, tile)
		tile.position = to_local(tile.position)
		tile.slide()
		return true
	else:
		return false


func empty() -> bool:
	return tile == null


func set_grid_position(r: int, c: int):
	row = r
	column = c


func adjacent(cell: Cell) -> bool:
	return (
		row - cell.row >= -1
		and row - cell.row <= 1
		and column - cell.column >= -1
		and column - cell.column <= 1
		and (not (row - cell.row == 0 and column - cell.column == 0))
	)


func compatible(cell: Cell) -> bool:
	return (
		selectable()
		&& cell.selectable()
		&& adjacent(cell)
		and tile.resource_name() == cell.tile.resource_name()
	)


func selectable() -> bool:
	return enabled && not empty()


func can_accept_tile() -> bool:
	return enabled && empty()


func select():
	$Selection.show()
	$Selection.play()


func deselect():
	$Selection.stop()
	$Selection.hide()


func pop() -> Tile:
	deselect()
	return take_tile()
