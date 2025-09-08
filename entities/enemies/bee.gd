extends Area2D

func _ready() -> void:
	var entityManager = EntityManager.new()
	add_child(entityManager)
	
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group(body.name.to_lower()) and body.is_immune == false:
		get_parent().player_damaged.emit()
		body.get_hit.emit()
