@tool
class_name PlayField extends Node2D

# 清了多少行
signal cleared(lines: int)

## 格子大小
const CELL_WIDTH = 25
## 格子线宽
const CELL_line_WIDTH = 2

## 天花板 
## 1~20行 颜色较深的那一部分
const CEILING = 20
## 缓冲区大小 
## 顶上颜色较淡的那三行
const BUFFER_ZONE_HEIGHT = 3


## _playfield容器水平方向的大小。
const H_CAPACITY = 10
## _playfield容器垂直方向的大小。
const V_CAPACITY = CEILING + BUFFER_ZONE_HEIGHT


# 二维数组，存储方块（Block）信息。 数据类型是：Array[Array[Block]]
var _playfield = []

func _init() -> void:
	_playfield.clear()
	for row in V_CAPACITY:
		
		var row_array = []
		for col in H_CAPACITY:
			row_array.append(null)
			
		_playfield.append(row_array)



func _draw() -> void:
	_draw_grid()
	_draw_blocks()


func _draw_grid():
	
	var l_to_r = H_CAPACITY * Vector2.RIGHT * CELL_WIDTH
	var b_to_t = CEILING * Vector2.UP * CELL_WIDTH
	
	var line_points:PackedVector2Array = PackedVector2Array()

	for i in H_CAPACITY + 1:
		var bottom_point = i * Vector2.RIGHT * CELL_WIDTH
		var top_point = bottom_point + b_to_t
		line_points.append(bottom_point)
		line_points.append(top_point)
	
	for i in CEILING + 1:
		var left_point = i * Vector2.UP * CELL_WIDTH
		var right_point = left_point + l_to_r
		line_points.append(left_point)
		line_points.append(right_point)
	
	var c = Color.WHITE
	c.a = 0.6
	
	draw_multiline(line_points, c, CELL_line_WIDTH)
	
	var line_points_2:PackedVector2Array = PackedVector2Array()
	for i in H_CAPACITY + 1:
		var bottom_point = i * Vector2.RIGHT * CELL_WIDTH + b_to_t
		var top_point = bottom_point + BUFFER_ZONE_HEIGHT * Vector2.UP * CELL_WIDTH
		line_points_2.append(bottom_point)
		line_points_2.append(top_point)
	
	for i in BUFFER_ZONE_HEIGHT:
		var left_point = (i + CEILING + 1) * Vector2.UP * CELL_WIDTH
		var right_point = left_point + l_to_r
		line_points_2.append(left_point)
		line_points_2.append(right_point)
	
	var color: Color = Color.WHITE
	color.a = 0.2
	
	draw_multiline(line_points_2, color, CELL_line_WIDTH)


## 绘制场地中的方块（Block）
func _draw_blocks() -> void:
	for row in _playfield.size():
		for col in _playfield[row].size():
			var block = _playfield[row][col]
			if block == null:
				continue
			var rect = Rect2(col * CELL_WIDTH, (row + 1) * -CELL_WIDTH, CELL_WIDTH, CELL_WIDTH).grow(-1)
			draw_rect(rect, block.color)


## 将给定方块正式添加入场地中。在此之前活动砖块只作显示，并未加入二维数组_playfield中。
func add_blocks(tetromino: Tetromino, coordinates: Vector2i) -> void:
	var blocks = tetromino.get_blocks()
	for row in blocks.size():
		for col in blocks[row].size():
			if (blocks[row][col]):
				_playfield[coordinates.y - row][coordinates.x + col] = Block.new(tetromino.COLOR)
	
	clear(tetromino, coordinates)
	queue_redraw()


# 判断给定砖块是否会与场地中已有的方块（Block）重叠。
func is_overlap(tetromino: Tetromino, coordinates: Vector2i) -> bool:
	var blocks = tetromino.get_blocks()
	for row in blocks.size():
		for col in blocks[row].size():
			if (blocks[row][col]):
				var i = coordinates.x + col
				var j = coordinates.y - row
				var rect = Rect2i(0, 0, H_CAPACITY, V_CAPACITY)
				if rect.has_point(Vector2i(i, j)):
					if _playfield[j][i] != null:
						return true
				else:
					return true
	return false


## 获取给定砖块在场地中幽灵砖块处的坐标
func get_lock_position(tetromino: Tetromino, start_coordinates: Vector2i) -> Vector2i:
	# I型方块从第23行到第1行需要移动22次。
	# 在下面代码中第一次循环其实是原地判定，所以对于I型移动22次则需要循环23次
	for i in V_CAPACITY + 1:
		if is_overlap(tetromino, start_coordinates + i * Coordinates.DOWN):
			if i == 0:
				break
				
			return start_coordinates + (i - 1) * Coordinates.DOWN
	return start_coordinates


## 开始做消行工作
func clear(tetromino: Tetromino, coordinates: Vector2i):
	var blocks = tetromino.get_blocks()
	var cleared_lines = 0
	for row in blocks.size():
		if blocks[row].any(func(ele): return ele != 0):
			if _playfield[coordinates.y - row].all(func(element): return element != null):
				line_clear(coordinates.y - row)
				cleared_lines += 1
		
	if cleared_lines != 0:
		cleared.emit(cleared_lines)


## 消除具体某一行
func line_clear(row: int):
	var null_row = _playfield.pop_at(row)
	null_row.fill(null)
	_playfield.push_back(null_row)
