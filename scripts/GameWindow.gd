extends Node2D


func _ready():
	load_level()


func load_level(level: String = "res://levels/default.json"):
	$ColorRect/Grid.load_level(level)
