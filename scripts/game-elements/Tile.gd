extends Node2D

class_name Tile

var tile_name: String


func _init(info: Dictionary):
	tile_name = info.name
	$Sprite.set_texture(load(info.sprite))


func slide():
	move_to(get_parent().position)
	pass


func move_to(target):
	$Tween.interpolate_property(
		self, "position", position, target, 0.4, Tween.TRANS_BOUNCE, Tween.EASE_OUT
	)
	$Tween.start()
