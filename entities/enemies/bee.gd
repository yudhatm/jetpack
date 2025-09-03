extends Area2D

func _ready() -> void:
	var entityManager = EntityManager.new()
	add_child(entityManager)
	
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.name.to_lower() == "player":
		#TODO: reduce player health
		pass
