extends Node2D


func _ready():
	load_level()


func _process(_delta):
	if Input.is_action_just_pressed("ui_touch"):
		var mouse_position := to_global(get_viewport().get_mouse_position())
		var grid = $ColorRect/Grid
		grid.click(grid.to_local(mouse_position))
		pass


func load_level(level: String = "res://levels/default.json"):
	$ColorRect/Grid.load_level(level)
