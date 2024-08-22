class_name Randomizer extends RefCounted

var tetromino_class_array = [Z, L, O, S, I, J, T]
var tetromino_array: Array[Tetromino] = []
var temp: Array[Tetromino] = []

func _init() -> void:
	tetromino_array = _get_shuffle_array()
	temp = _get_shuffle_array()


func provide() -> Tetromino:
	var tetromino = tetromino_array.pop_front()
	tetromino_array.push_back(temp.pop_back())
	if temp.is_empty():
		temp = _get_shuffle_array()
		
	return tetromino


func _get_shuffle_array() -> Array[Tetromino]:
	var result: Array[Tetromino] = []
	for i in tetromino_class_array:
		result.push_back(i.new())
	
	result.shuffle()
	return result
