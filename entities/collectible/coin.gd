extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	var entityManager = EntityManager.new()
	add_child(entityManager)

func _on_body_entered(body: Node2D) -> void:
	#TODO: Increase collected coin count and destroy
	if body.name.to_lower() == "player":
		get_parent().increase_coin_count.emit()
		animation_player.play("picked_up")
