class_name GhostPiece extends Node2D

@export var _playfield: PlayField
@export var _entity: ActivePiece

func _ready() -> void:
	_entity.coordinatesChanged.connect(func ():queue_redraw())


func _draw() -> void:
	var coordinate = _playfield.get_lock_position(_entity.tetromino, _entity.coordinates)
	if coordinate == _entity.coordinates:
		return
	
	var color: Color = _entity.tetromino.COLOR
	color.a = 0.6
	Global.draw_tetromino(self, _entity.tetromino, coordinate, color)
	
