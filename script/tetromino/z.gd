class_name Z extends Tetromino

const COLOR: Color = Color.RED

const STATE_0 = [[1, 1, 0], 
				[0, 1, 1],
				[0, 0, 0]]

const STATE_R = [[0, 0, 1], 
				[0, 1, 1],
				[0, 1, 0]]

const STATE_2 = [[0, 0, 0], 
				[1, 1, 0],
				[0, 1, 1]]

const STATE_L = [[0, 1, 0], 
				[1, 1, 0],
				[1, 0, 0]]

func _init() -> void:
	state_array = [STATE_0, STATE_R, STATE_2, STATE_L]
