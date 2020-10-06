extends Node2D

class_name Tile

var info: Dictionary


func init(i: Dictionary):
	info = i
	$Sprite.set_texture(load(info.sprite))


func slide():
	move_to(Vector2(0, 0))
	pass


func move_to(target):
	$Tween.interpolate_property(
		self, "position", position, target, 0.4, Tween.TRANS_BOUNCE, Tween.EASE_OUT
	)
	$Tween.start()


func resource_name() -> String:
	return info.name
