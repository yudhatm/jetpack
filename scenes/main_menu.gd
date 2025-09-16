extends Control

@onready var play: Button = $CanvasLayer/play

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play.pressed.connect(_on_play_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
