extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var camera = get_viewport().get_camera_2d()
	
	if camera:
		if position.x < camera.global_position.x - 100:
			queue_free()
