extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var dirt = preload("res://scenes/backtiles/DirtTile.tscn")
	
	var _1 = dirt.instance()
	var _2 = dirt.instance()
	
	add_child(_1)
	add_child(_2)
	
	_1.position = Vector2(64,800)
	_2.position = Vector2(128,800)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
