extends Sprite

class_name BackTile

signal destroyed

var full := false
var stages: Array
var current_stage: int


func init(info: Dictionary):
	full = true
	stages = info.stages
	set_texture(load(stages[0].sprite))
	current_stage = 0


func hit():
	if not full:
		return

	current_stage += 1
	if current_stage >= stages.size():
		full = false
		set_texture(null)
		hide()
		emit_signal("destroyed")
	else:
		set_texture(stages[current_stage])
