extends Node2D

const START_SPEED = 100.0
const MAX_SPEED = 300.0
const SPEED_INCREASE = 25.0
const CAMERA_OFFSET = -20
const TILE_MOVE_DISTANCE = 0.5
const TILE_REPOSITION_DISTANCE = 0.2
const SPAWN_OFFSET = 30
const SURFACE_OFFSET = 16
const SCORE_UPDATE_INTERVAL = 0.1
const TOP_SPAWN_EDGE = 30
const MIDDLE_SPAWN_EDGE = 75
const BOTTOW_SPAWN_EDGE = 130
const COIN_SCORE = 100

signal increase_coin_count
signal player_damaged

@onready var ground_tile: TileMapLayer = $GroundTile
@onready var player: CharacterBody2D = $Player
@onready var camera: Camera2D = $Camera2D
@onready var sky_border: StaticBody2D = $SkyBorder
@onready var environment_timer: Timer = $EnvironmentTimer
@onready var spawn_timer: Timer = $SpawnTimer
@onready var hud: CanvasLayer = $HUD

var tree_scene = preload("res://entities/background/tree.tscn")
var bee = preload("res://entities/enemies/bee.tscn")
var coin = preload("res://entities/collectible/coin.tscn")

var player_health: int = 3
var speed: float = 0
var screen_size: Vector2
var score: int = 0
var score_timer: float = 0.0
var spawn_wait_time = 2.0

var startingPos: Vector2
var tileStartingPos: Vector2
var totalDistance: float = 0.0
var distance_threshold = 500.0

var rng = RandomNumberGenerator.new()
var spawn_coordinate = [TOP_SPAWN_EDGE, MIDDLE_SPAWN_EDGE, BOTTOW_SPAWN_EDGE]
var weights = [1, 1, 2]
var spawn_priority = ["enemy", "coin"]
var priority_weights = [2, 1]

func _ready():
	screen_size = get_viewport().get_visible_rect().size
	get_viewport().size_changed.connect(_on_viewport_size_changed)
	
	increase_coin_count.connect(_increment_coin)
	player_damaged.connect(_reduce_health)
	startingPos = player.global_position
	tileStartingPos = ground_tile.position  
	
	reset_game()

func _process(delta):
	camera.global_position.x = player.global_position.x + CAMERA_OFFSET
	
	if camera.global_position.x - ground_tile.position.x > screen_size.x * TILE_MOVE_DISTANCE:
		ground_tile.position.x += screen_size.x * TILE_REPOSITION_DISTANCE
		sky_border.position.x += screen_size.x * TILE_REPOSITION_DISTANCE
	
	score_timer += delta
	
	if score_timer >= SCORE_UPDATE_INTERVAL:
		_calculate_score()
		score_timer = 0.0
	
	updateSpeed()
	
func _on_viewport_size_changed():
	screen_size = get_viewport().get_visible_rect().size
	
func reset_game():
	speed = START_SPEED
	score = 0
	score_timer = 0.0
	totalDistance = 0.0
	spawn_wait_time = 2.0
	player.position = startingPos
	ground_tile.position = tileStartingPos
	
	_spawn_environment()
	_spawn_enemies()
	
func updateSpeed():
	totalDistance = abs(player.position.x - startingPos.x)
	
	if totalDistance >= distance_threshold and speed < MAX_SPEED:
		speed += SPEED_INCREASE
		distance_threshold += distance_threshold * 1.5
		spawn_wait_time -= 0.1
		
	speed = clamp(speed, START_SPEED, MAX_SPEED)

func _spawn_environment():
	var tree = tree_scene.instantiate()
	add_child(tree)
	tree.position.x = player.position.x + screen_size.x + SPAWN_OFFSET
	tree.position.y = screen_size.y - SURFACE_OFFSET
	
	environment_timer.wait_time = randf_range(1.0, 2.0)
	environment_timer.start()
	
func _spawn_enemies():
	var spawn_coordinate = spawn_coordinate[rng.rand_weighted(weights)]
	var pattern_amount = randi_range(1, 3)
	
	var bee1 = bee.instantiate()
	var bee2 = bee.instantiate()
	var bee3 = bee.instantiate()
	
	add_child(bee1)
	
	bee1.position.x = player.position.x + screen_size.x + SPAWN_OFFSET
	bee1.position.y = spawn_coordinate
	
	var BEE_X_LEFT = bee1.position.x - 16
	var BEE_X_RIGHT = bee1.position.x + 16
	var BEE_Y_TOP = bee1.position.y - 16
	var BEE_Y_BOTTOM = bee1.position.y + 16 
	
	match pattern_amount:
		1:
			pass #Do Nothing
		2:
			add_child(bee2)
			
			bee2.position.x = [BEE_X_LEFT, BEE_X_RIGHT].pick_random()
			bee2.position.y = BEE_Y_TOP
		3:
			add_child(bee2)
			add_child(bee3)
			
			var bee2_x_pos = [BEE_X_LEFT, BEE_X_RIGHT].pick_random()
			
			bee2.position.x = bee2_x_pos
			bee2.position.y = BEE_Y_TOP
			
			bee3.position.x = BEE_X_LEFT if bee2_x_pos == BEE_X_RIGHT else BEE_X_RIGHT
			bee3.position.y = BEE_Y_BOTTOM
	
	spawn_timer.wait_time = spawn_wait_time
	spawn_timer.start()
	
func _spawn_coins():
	var spawn_coordinate = spawn_coordinate[rng.rand_weighted(weights)]
	var coin_count = randi_range(3, 8)
	
	for i in coin_count:
		var new_coin = coin.instantiate()
		add_child(new_coin)
		
		new_coin.position = Vector2(player.position.x + screen_size.x + SPAWN_OFFSET + (i * 20), spawn_coordinate)
	
	spawn_timer.wait_time = spawn_wait_time
	spawn_timer.start()

func _increment_coin():
	score += COIN_SCORE
	
func _reduce_health():
	player_health -= 1
	print("Health: " + str(player_health))
	hud.update_heart_display()
	
	if player_health <= 0:
		print("Game over!")
		get_tree().paused = true
		hud.game_over_screen.visible = true
		

func _calculate_score():
	var base_score = 10
	var bonus_score = max(0, (speed - START_SPEED) / 50)
	var total_score = base_score + bonus_score
	score += total_score

func _on_environment_timer_timeout() -> void:
	_spawn_environment()
	
func _on_spawn_timer_timeout() -> void:
	var selected_spawn_node = spawn_priority[rng.rand_weighted(priority_weights)]
	match selected_spawn_node:
		"enemy":
			_spawn_enemies()
		"coin":
			_spawn_coins()
