extends Node2D


func _ready():
	load_level()


func _process(_delta):
	if Input.is_action_just_pressed("ui_touch"):
		var mouse_position := to_global(get_viewport().get_mouse_position())
		var grid = $GridHolder/Grid
		grid.click(grid.to_local(mouse_position))
		pass


func load_level(level: String = "res://levels/default.json"):
	$GridHolder/Grid.load_level(level)


func _on_Grid_complete_chain(tiles_list):
	var backpack: Button = $TopBarHolder/Backpack
	var backpack_center := backpack.rect_position + (backpack.rect_size / 2)
	for tile in tiles_list:
		add_child(tile)
		tile.position = to_local(tile.position)
		#var a = tile.get_children()[1]
		#var b = tile.get_child_count()
		var c = tile.get_child(0)
		c.interpolate_property(
			tile,
			"position",
			tile.position,
			backpack_center,
			0.4,
			Tween.TRANS_BOUNCE,
			Tween.EASE_OUT
		)
