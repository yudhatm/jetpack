extends CanvasLayer

@onready var score: Label = $Score

var parent_node: Node2D

func _ready() -> void:
	parent_node = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	score.text = "Score: " + str(parent_node.score)
