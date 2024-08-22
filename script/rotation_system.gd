class_name RotationSystem extends Node


const tick_table_common = {
					&"0_to_R" : [Vector2i(0,0),Vector2i(-1,0),Vector2i(-1,1),Vector2i(0,-2),Vector2i(-1,2)], 
					&"R_to_0" : [Vector2i(0,0),Vector2i(1,0),Vector2i(1,-1),Vector2i(0,2),Vector2i(1,2)],
					&"R_to_2" : [Vector2i(0,0),Vector2i(1,0),Vector2i(1,-1),Vector2i(0,2),Vector2i(1,2)],
					&"2_to_R" : [Vector2i(0,0),Vector2i(-1,0),Vector2i(-1,1),Vector2i(0,-2),Vector2i(-1,-2)],
					&"2_to_L" : [Vector2i(0,0),Vector2i(1,0),Vector2i(1,1),Vector2i(0,-2),Vector2i(1,-2)], 
					&"L_to_2" : [Vector2i(0,0),Vector2i(-1,0),Vector2i(-1,-1),Vector2i(0,2),Vector2i(-1,2)],
					&"L_to_0" : [Vector2i(0,0),Vector2i(-1,0),Vector2i(-1,-1),Vector2i(0,2),Vector2i(-1,2)], 
					&"0_to_L" : [Vector2i(0,0),Vector2i(1,0),Vector2i(1,1),Vector2i(0,-2),Vector2i(1,-2)]
	}

const tick_table_i = {
					&"0_to_R" : [Vector2i(0,0),Vector2i(-2,0),Vector2i(1,0),Vector2i(-2,-1),Vector2i(1,2)], 
					&"R_to_0" : [Vector2i(0,0),Vector2i(2,0),Vector2i(-1,0),Vector2i(2,1),Vector2i(-1,-2)],
					&"R_to_2" : [Vector2i(0,0),Vector2i(-1,0),Vector2i(2,0),Vector2i(-1,2),Vector2i(2,-1)],
					&"2_to_R" : [Vector2i(0,0),Vector2i(1,0),Vector2i(-2,0),Vector2i(1,-2),Vector2i(-2,1)],
					&"2_to_L" : [Vector2i(0,0),Vector2i(2,0),Vector2i(-1,0),Vector2i(2,1),Vector2i(-1,-2)], 
					&"L_to_2" : [Vector2i(0,0),Vector2i(-2,0),Vector2i(1,0),Vector2i(-2,-1),Vector2i(1,2)],
					&"L_to_0" : [Vector2i(0,0),Vector2i(1,0),Vector2i(-2,0),Vector2i(+1,-2),Vector2i(-2,1)], 
					&"0_to_L" : [Vector2i(0,0),Vector2i(-1,0),Vector2i(2,0),Vector2i(-1,2),Vector2i(2,-1)]
	}


static func get_test_points(tetromino: Tetromino, key: String) -> Array:
	match typeof(tetromino):
		I:
			return tick_table_i[key]
		O:
			return [Vector2i.ZERO]
		_:
			return tick_table_common[key]


static func get_state_string(orientation):
	match orientation:
		0:
			return '0'
		1:
			return 'R'
		2:
			return '2'
		3:
			return 'L'
