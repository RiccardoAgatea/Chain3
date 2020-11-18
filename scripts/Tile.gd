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
	$Tween.connect("tween_completed", self, "_on_Tween_tween_all_completed")
	$Tween.interpolate_property(
		self, "position", position, inventory_position, 0.3, Tween.TRANS_QUINT, Tween.EASE_IN_OUT
	)
	var collected_resources: Dictionary = info["resources"].duplicate(true)
	$Tween.start()
	return collected_resources


func _on_Tween_tween_all_completed(o, k):
	hide()
	queue_free()
