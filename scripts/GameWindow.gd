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
	$GridHolder/Grid.pause()
	$ResourcesOverlay.show()


func _on_ResourcesOverlay_close():
	$ResourcesOverlay.hide()
	$GridHolder/Grid.resume()


func _on_Grid_level_won():
	$GridHolder/Grid.pause()
	$GridHolder/Grid.hide()
	$EndLevel.set_title("You won!")
	$EndLevel.set_resources($ResourcesOverlay.resources)
	$EndLevel.show()
