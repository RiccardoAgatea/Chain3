extends Node2D

class_name BasePiece

export (String) var resource
export (int) var quantity

func select() -> void:
	$Sprite.set_texture(load(get_selected_path()))

func deselect() -> void:
	$Sprite.set_texture(load(get_default_path()))

func get_default_path() -> String:
	return ""

func get_selected_path() -> String:
	return ""

func get_class() -> String:
	return "BasePiece"

func move_to(target):
	$Tween.interpolate_property(self, "position", position, target, 0.4, Tween.TRANS_BOUNCE,Tween.EASE_OUT)
	$Tween.start()
