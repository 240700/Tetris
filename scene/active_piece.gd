class_name ActivePiece extends Node2D

## 锁定延迟 单位：秒
const LOCK_DELAY = 0.5
## 移动节流 如：0.1s/次，表示每0.1秒内只能移动一次
const MOVE_THROTTLE = 0.1
## 进入延迟 当新砖块生成后延迟一段时间才能活动（移动和下落，但能旋转），
## 独立于下落，仅在新砖块中有效。 单位：秒
const ENTRY_DELAY = 0.1
## 多少秒下落一次
const GRAVITY = 1.0


signal coordinatesChanged
signal gameovered(type: Global.GameOverType)

@export var _playfield: PlayField
@export var next_queue: NextQueue
@export var hold_piece: HoldPiece

@onready var fall_timer: Timer = $FallTimer
@onready var move_timer: Timer = $MoveTimer
@onready var lock_delay_timer: Timer = $LockDelayTimer

var tetromino: Tetromino
var coordinates: Vector2i:
	set = _set_coordinates

var is_landing: bool = false :
	set = _set_is_landing

var is_can_move: bool = false :
	set(value):
		is_can_move = value
		if value:
			move_timer.stop()
		else:
			move_timer.start()

var can_hold: bool = true:
	set(value):
		can_hold = value
		hold_piece.ghost(!can_hold)


func _ready() -> void:
	_init_timer()
	next_tetromino()


func _unhandled_input(event: InputEvent) -> void:
	var move_axis = Input.get_axis("move_left", "move_right")
	if (move_axis != 0):
		var orientation = Vector2i(sign(move_axis), 0)
		move(orientation)
		
	if event.is_action_pressed("rotation_left"):
		_m_rotate(-1)
	
	if event.is_action_pressed("rotation_right"):
		_m_rotate(1)
	
	if event.is_action_pressed("soft_drop"):
		soft_down(true)
	
	if event.is_action_released("soft_drop"):
		soft_down(false)
	
	if event.is_action_pressed("hard_drop"):
		hard_down()
	
	if event.is_action_pressed("hold"):
		hold()



func move(orientation: Vector2i):
	if not is_can_move:
		return
	
	if not _playfield.is_overlap(tetromino, coordinates + orientation):
		coordinates += orientation
		is_can_move = false
		queue_redraw()


func soft_down(is_enable: bool):
	if is_enable:
		fall_timer.timeout.emit()
		fall_timer.start(GRAVITY / 5)
	else :
		fall_timer.start(GRAVITY)


func hard_down():
	coordinates = _playfield.get_lock_position(tetromino, coordinates)


func fall():
	if not _playfield.is_overlap(tetromino, coordinates + Coordinates.DOWN):
		coordinates += Coordinates.DOWN
		queue_redraw()


func lock():
	# 踢墙有时会超出容器范围
	if coordinates.y >= PlayField.V_CAPACITY:
		gameovered.emit(Global.GameOverType.OVERFLOW)
		
	fall_timer.stop()
	is_landing = false
	_playfield.add_blocks(tetromino, coordinates)
	next_tetromino()


func next_tetromino():
	tetromino = next_queue.provice()
	if tetromino is I:
		coordinates = Vector2i(3, 23)
	else:
		coordinates = Vector2i(3, 22)
	
	
	if _playfield.is_overlap(tetromino, coordinates):
		gameovered.emit(Global.GameOverType.OVERLAPPED)
	
	await get_tree().create_timer(ENTRY_DELAY).timeout
	fall_timer.start()
	is_can_move = true
	can_hold = true


func hold():
	if not can_hold:
		return
	
	can_hold = false
	
	tetromino = hold_piece.hold(tetromino)
	if tetromino == null:
		next_tetromino()
	else:
		if tetromino is I:
			coordinates = Vector2i(3, 23)
		else:
			coordinates = Vector2i(3, 22)


func _draw() -> void:
	Global.draw_tetromino(self, tetromino, coordinates)


# 向左旋转是-1， 向右旋转是1
func _m_rotate(_rotate_orientation) -> bool:
	var test_points = get_test_points(_rotate_orientation)
	
	var coordinates_duplicate: Vector2i = coordinates * 1
	
	tetromino.orientation = (tetromino.orientation + _rotate_orientation + 4) % 4
	
	for point in test_points:
		if not _playfield.is_overlap(tetromino, coordinates + point):
			coordinates += point
			return true
	
	self.coordinates = coordinates_duplicate
	
	return false


## 获取所有踢墙测试点
func get_test_points(_rotate_orientation) -> Array:
	var format_string = "%s_to_%s"
	var _1 = RotationSystem.get_state_string(tetromino.orientation)
	var _2 = RotationSystem.get_state_string((tetromino.orientation + _rotate_orientation + 4) % 4)
	var key = format_string % [_1, _2]
	return RotationSystem.get_test_points(tetromino, key)


func _init_timer():
	fall_timer.wait_time = GRAVITY
	fall_timer.autostart = true
	fall_timer.timeout.connect(fall)
	
	move_timer.wait_time = MOVE_THROTTLE
	move_timer.timeout.connect(_on_move_timer_time_out)
	
	lock_delay_timer.wait_time = LOCK_DELAY
	lock_delay_timer.one_shot = true
	lock_delay_timer.timeout.connect(lock)


func _set_is_landing(value: bool):
	if is_landing != value:
		if(value):
			lock_delay_timer.start()
		else:
			lock_delay_timer.stop()
			
		is_landing = value


func _set_coordinates(value: Vector2i):
	coordinates = value
	coordinatesChanged.emit()
	queue_redraw()
	
	is_landing = _playfield.is_overlap(tetromino, coordinates + Coordinates.DOWN)


func _on_move_timer_time_out():
	is_can_move = true
