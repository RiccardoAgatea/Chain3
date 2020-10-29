extends Node2D

class_name Tile

var info: Dictionary


func init(i: Dictionary):
	info = i
	$Sprite.set_texture(load(info.sprite))


func slide():
	move_to(Vector2(0, 0))


func move_to(target):
	$Tween.interpolate_property(
		self, "position", position, target, 0.6, Tween.TRANS_BOUNCE, Tween.EASE_OUT
	)
	$Tween.start()


func resource_name() -> String:
	return info.name


func collect(inventory_position):
	$Tween.connect(
		"tween_all_completed", self, "_on_Tween_tween_all_completed", [], CONNECT_ONESHOT
	)
	$Tween.interpolate_property(
		self, "position", position, inventory_position, 0.3, Tween.TRANS_QUINT, Tween.EASE_IN_OUT
	)
	$Tween.start()
	return info["resources"].duplicate(true)


func _on_Tween_tween_all_completed():
	queue_free()
