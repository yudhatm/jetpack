extends CanvasLayer

@onready var score: Label = $Score
@onready var game_over_screen: CanvasLayer = $game_over_screen

var parent_node: Node2D
var hearts_list: Array[TextureRect]

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
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

func _on_main_menu_pressed() -> void:
	parent_node.reset_game()
	get_tree().paused = false
	get_tree().reload_current_scene()
	
