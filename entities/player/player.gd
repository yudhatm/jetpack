extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var anim2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
		if velocity.y < 0:
			anim2d.play("jump")
		else:
			anim2d.play("fall")
	else:
		anim2d.play("running")

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	move_and_slide()
