extends MarginContainer

class_name ResourceTab


func set_sprite(path: String):
	$HSplitContainer/TextureRect.set_texture(load(path))


func set_name(name: String):
	$HSplitContainer/Label.set_text(name)


func set_quantity(quantity: int):
	$HSplitContainer/Label2.set_text(String(quantity))


func set_info(path: String, name: String, quantity: int):
	set_sprite(path)
	set_name(name)
	set_quantity(quantity)
