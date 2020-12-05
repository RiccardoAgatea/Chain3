extends Node2D


func _ready():
	load_level()


func load_level(level: String = "res://levels/default.json"):
	$GridHolder/Grid.load_level(level)


func _on_Grid_complete_chain(tiles_list):
	var backpack: Button = $TopBarHolder/Backpack
	var backpack_center := backpack.rect_position + (backpack.rect_size / 2)
	for tile in tiles_list:
		add_child(tile)
		tile.position = to_local(tile.position)
		$ResourcesOverlay.add_resources(tile.collect(backpack_center))
	$GridHolder/Grid.refill()


func _on_Backpack_pressed():
	# TODO: Add pause game
	$GridHolder/Grid.pause()
	$ResourcesOverlay.show()


func _on_ResourcesOverlay_close():
	# TODO: Add resume game
	$ResourcesOverlay.hide()
	$GridHolder/Grid.resume()
