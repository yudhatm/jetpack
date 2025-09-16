extends CanvasLayer

@onready var score: Label = $Score

var parent_node: Node2D
var hearts_list: Array[TextureRect]

func _ready() -> void:
	parent_node = get_parent()
	
	var hearts_textures = $heartBoxContainer
	for child in hearts_textures.get_children():
		hearts_list.append(child)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	score.text = "Score: " + str(parent_node.score)
	
func update_heart_display():
	for i in range(hearts_list.size()):
		hearts_list[i].visible = i < parent_node.player_health
