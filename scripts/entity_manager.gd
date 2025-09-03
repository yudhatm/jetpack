extends Node2D
class_name EntityManager

var camera: Camera2D
const CLEANUP_DISTANCE = 100

func _ready() -> void:
	camera = get_viewport().get_camera_2d()
	
func _process(delta: float) -> void:
	if camera and get_parent():
		if get_parent().position.x < camera.global_position.x - CLEANUP_DISTANCE:
			get_parent().queue_free()
