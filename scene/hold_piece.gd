class_name HoldPiece extends Node2D

const WiDTH = 6
const HIGHT = 4

var is_ghost = false

var hold_piece: Tetromino


func hold(tetromino: Tetromino) -> Tetromino:
	var temp = hold_piece
	hold_piece = tetromino
	hold_piece.orientation = 0
	is_ghost = true
	queue_redraw()
	return temp

func ghost(enable: bool):
	is_ghost = enable
	queue_redraw()

func _draw() -> void:
	draw_rect(Rect2(0, 0, \
		WiDTH * PlayField.CELL_WIDTH, HIGHT * PlayField.CELL_WIDTH), Color.WHITE, false, 6)
	
	if hold_piece != null:
		var color: Color = hold_piece.COLOR
		if is_ghost:
			color.a = 0.3
			
		Global.draw_tetromino(self, hold_piece, Vector2i(1, -2), color)
