class_name Arena extends  Node2D

var cleared_lines: int:
	set(value):
		cleared_lines = value
		score.text = str(value)

@onready var play_field: PlayField = $PlayField
@onready var score: Label = $CanvasLayer/HBoxContainer/Score

@onready var panel: Panel = $CanvasLayer/Panel
@onready var reason: Label = $CanvasLayer/Panel/VBoxContainer/Reason
@onready var active_piece: ActivePiece = $PlayField/ActivePiece

func _ready() -> void:
	score.text = '0'
	play_field.cleared.connect(_on_playfield_cleared)
	active_piece.gameovered.connect(_on_gameovered)


func _on_playfield_cleared(lines: int):
	cleared_lines += lines


func _on_gameovered(type: Global.GameOverType):
	get_tree().paused = true
	var reason_str: String
	match type:
		Global.GameOverType.OVERLAPPED:
			reason_str = '方块重叠'
		Global.GameOverType.OVERFLOW:
			reason_str = '方块溢出'
			
	reason.text = reason_str
	panel.show()


func restart():
	get_tree().paused = false
	get_tree().reload_current_scene()
