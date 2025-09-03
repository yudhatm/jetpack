extends Node2D

func _ready() -> void:
	var entityManager = EntityManager.new()
	add_child(entityManager)
