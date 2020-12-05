extends Node2D

var GRID = preload("res://scenes/Grid.tscn")
var grid


func _ready():
	play()


func play():
	$ResourcesOverlay.reset()
	load_level()


func load_level(level: String = "res://levels/default.json"):
	if grid:
		grid.queue_free()

	grid = GRID.instance()
	$GridHolder.add_child(grid)
	grid.position = Vector2(0, 0)

	grid.connect("complete_chain", self, "_on_Grid_complete_chain")
	grid.connect("level_won", self, "_on_Grid_level_won")

	grid.load_level(level)


func _on_Grid_complete_chain(tiles_list):
	var backpack: Button = $TopBarHolder/Backpack
	var backpack_center := backpack.rect_position + (backpack.rect_size / 2)
	for tile in tiles_list:
		add_child(tile)
		tile.position = to_local(tile.position)
		$ResourcesOverlay.add_resources(tile.collect(backpack_center))
	grid.refill()


func _on_Backpack_pressed():
	grid.pause()
	$ResourcesOverlay.show()


func _on_ResourcesOverlay_close():
	$ResourcesOverlay.hide()
	grid.resume()


func _on_Grid_level_won():
	grid.pause()
	grid.hide()
	$EndLevel.set_title("You won!")
	var acquired_resources: Dictionary = $ResourcesOverlay.resources
	$EndLevel.set_resources(acquired_resources)
	$EndLevel.show()
	Global.add_resources(acquired_resources)


func _on_EndLevel_close():
	$EndLevel.hide()
	play()
