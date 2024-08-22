class_name Tetromino


var state_array = []
var orientation = 0

func get_blocks():
	return state_array[orientation]

func get_init_blocks():
	return state_array[0]
