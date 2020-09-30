extends Node2D

# Dimensions (in slots) of the grid
export (int) var width;
export (int) var height;

# Position of the center of the bottom right piece
export (int) var x_start;
export (int) var y_start;

# Length of the side of a cell
export (int) var offset;

# Piece types
var piece_types := [
	preload("res://scenes/pieces/BerryPiece.tscn"),
	preload("res://scenes/pieces/GoldPiece.tscn"),
	preload("res://scenes/pieces/LeafPiece.tscn"),
	preload("res://scenes/pieces/MushroomPiece.tscn"),
	preload("res://scenes/pieces/StonePiece.tscn"),
	preload("res://scenes/pieces/WoodPiece.tscn")
];

# Grid holding the pieces
var grid := []

# List of selected pieces
var selected := []

# State control
var user_active := true

func _ready():
	randomize()
	
	for i in width:
		grid.append([])
		for j in height:
			grid[i].append(null)
	
	spawn_grid()

func create_piece() -> BasePiece :
	var piece: BasePiece = piece_types[randi() % piece_types.size()].instance()
	add_child(piece)
	return piece

func spawn_grid():
	refill_columns()
#	for i in width:
#		for j in height:
#			#grid[i][j] = 
#			var piece: BasePiece = create_piece()
#			piece.position = grid_to_pixel(i, j)
#			grid[i][j] = piece

func grid_to_pixel(column: int, row: int) -> Vector2:
	var x: int = x_start + offset * column
	# Minus because we count rows from the bottom up
	var y: int = y_start - offset * row

	return Vector2(x,y)

func pixel_to_grid(x:int, y:int) -> Vector2:
	var column: int = round((x - x_start) / (offset as float)) as int
	var row: int = round((y_start - y) / (offset as float)) as int
	return Vector2(column, row)

# Still missing the case 'click on piece that was already selected'
# Change:
# If click on last cell selected, activate the 'get resource thing', todo
# If click on selected cell that's not the last, deselect every cell from the last back to the clicked
func select_piece(column, row) -> void:
	var piece: BasePiece = grid[column][row]
	
	# Prevents breaking if you try to make a chain right after the old one disappeared
	if piece == null:
		return
	
	if selected == []:
		selected.append([column, row])
		piece.select()
	elif [column, row] == selected.back():
		user_active = false
		destroy_selected()
	elif selected.has([column, row]):
		while selected.back() != [column, row]:
			var cell = selected.pop_back()
			grid[cell[0]][cell[1]].deselect()
	elif piece.get_class() == grid[selected.front()[0]][selected.front()[1]].get_class() and abs(selected.back()[0] - column) <= 1 and abs(selected.back()[1] - row) <= 1:
		selected.append([column, row])
		piece.select()
	else:
		deselect_all()

func touch() -> void:
	var position := get_viewport().get_mouse_position()
	
	# Check if the mouse is inside the grid
	if position.x < (get_parent() as Control).rect_position.x or position.x >= (get_parent() as Control).rect_position.x + (get_parent() as Control).rect_size.x or position.y < (get_parent() as Control).rect_position.y or position.y >= (get_parent() as Control).rect_position.y + (get_parent() as Control).rect_size.y:
		deselect_all()
	else:
		var cell := pixel_to_grid(position.x as int, position.y as int)
		select_piece(cell.x, cell.y)

func deselect_all() -> void:
	while selected != []:
		var cell = selected.pop_back()
		grid[cell[0]][cell[1]].deselect()

# warning-ignore:unused_argument
func _process(delta):
	if user_active:
		if Input.is_action_just_pressed("ui_touch"):
			touch()

func destroy_selected():
	while selected != []:
		var cell = selected.pop_front()
		grid[cell[0]][cell[1]].queue_free()
		grid[cell[0]][cell[1]] = null
	
	$CollapseTimer.start()

func collapse_columns():
	for i in width:
		for j in height:
			if grid[i][j] == null:
				for k in range(j+1, height):
					if grid[i][k] != null:
						grid[i][k].move_to(grid_to_pixel(i,j))
						grid[i][j] = grid[i][k]
						grid[i][k] = null
						break

func refill_columns():
	for i in width:
		for j in height:
			if grid[i][j] == null:
				grid[i][j] = create_piece()
				grid[i][j].position = grid_to_pixel(i, height)
				grid[i][j].move_to(grid_to_pixel(i,j))

func _on_CollapseTimer_timeout():
	collapse_columns()
	refill_columns()
	user_active = true
