extends CharacterBody2D

@export var jetpack_force = 400.0
@export var fall_force = 400.0
@export var air_resistance = 0.98
@export var max_fall_speed = 100.0
@export var max_rise_speed = -300.0

@onready var anim2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_flash_anim: AnimationPlayer = $HitFlashAnimationPlayer
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var invis_timer: Timer = $InvisibleTimer

var main_script
var is_jumping = false
var is_immune = false

signal get_hit

func _ready() -> void:
	main_script = get_parent()
	get_hit.connect(_get_hit)

func _physics_process(delta):
	velocity.x = main_script.speed
	
	if not is_on_floor():
		if is_jumping:
			anim2d.play("jump")
		else:
			anim2d.play("fall")
	else:
		anim2d.play("running")
	
	# Jetpack thrust when button is held
	if Input.is_action_pressed("jump"):
		velocity.y -= jetpack_force * delta
		is_jumping = true
	else:
		velocity.y += fall_force * delta
		is_jumping = false
		
	velocity.y *= air_resistance                                                     
	
	# Clamp the vertical velocity
	velocity.y = clamp(velocity.y, max_rise_speed, max_fall_speed)
 
	move_and_slide()
	
func _get_hit():
	if not is_immune:
		is_immune = true 
		hit_flash_anim.play("hit_flash")
		invis_timer.start()

func _on_invisible_timer_timeout() -> void:
	is_immune = false
