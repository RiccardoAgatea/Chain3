extends Node2D

class_name Cell

# Layers
onready var back := $BackTile  #back
var tile: Tile = null  #sprite
onready var effect := $FrontTile  #front


func make_tile(info: Dictionary) -> bool:
	if not empty():
		return false

	return acquire_tile(Tile.new(info))


func take_tile() -> Tile:
	if tile != null:
		remove_child(tile)
		tile.free()

	var t := tile
	tile = null
	return t


func acquire_tile(t: Tile) -> bool:
	if tile == null:
		tile = t
		add_child_below_node(tile, back)
		tile.slide()
		return true
	else:
		return false


func empty() -> bool:
	return tile == null
