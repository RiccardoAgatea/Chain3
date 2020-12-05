extends MarginContainer

class_name ResourceTab


func set_sprite(path: String):
	$VBoxContainer/HSplitContainer/TextureRect.set_texture(load(path))


func set_name(name: String):
	$VBoxContainer/HSplitContainer/Label.set_text(name)


func set_quantity(quantity: int, differencial: bool = false, original_quantity: int = 0):
	if differencial:
		$VBoxContainer/HBoxContainer/Label2.set_text(String(original_quantity))
		$VBoxContainer/HBoxContainer/Label3.set_text(">")
		$VBoxContainer/HBoxContainer/Label4.set_text(String(original_quantity + quantity))
		$VBoxContainer/HBoxContainer/Label3.show()
		$VBoxContainer/HBoxContainer/Label4.show()

		$VBoxContainer/HBoxContainer.set_alignment($VBoxContainer/HBoxContainer.ALIGN_CENTER)
	else:
		$VBoxContainer/HBoxContainer/Label2.set_text(String(quantity))
		$VBoxContainer/HBoxContainer/Label3.hide()
		$VBoxContainer/HBoxContainer/Label4.hide()

		$VBoxContainer/HBoxContainer.set_alignment($VBoxContainer/HBoxContainer.ALIGN_END)


func set_info(
	path: String,
	name: String,
	quantity: int,
	differencial: bool = false,
	original_quantity: int = 0
):
	set_sprite(path)
	set_name(name)
	set_quantity(quantity, differencial, original_quantity)
