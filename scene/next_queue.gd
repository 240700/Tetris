class_name NextQueue extends Node2D

var randomizer: Randomizer = Randomizer.new()

# 预览 3 个
const CAPACITY = 3

const WIDTH = 6
const HIGHT = 10

var next_queue: Array[Tetromino] = []


func _init() -> void:
	for i in CAPACITY:
		next_queue.push_back(randomizer.provide())


func _draw() -> void:
	draw_rect(Rect2(0, - HIGHT * PlayField.CELL_WIDTH, \
		WIDTH * PlayField.CELL_WIDTH, HIGHT * PlayField.CELL_WIDTH), Color.WHITE, false, 6)
	
	for i in next_queue.size():
		Global.draw_tetromino(self, next_queue[i], Vector2i(1, HIGHT - 2 - i * 3))


func provice() -> Tetromino:
	var next_piece = next_queue.pop_front()
	next_queue.push_back(randomizer.provide())
	queue_redraw()
	return next_piece
