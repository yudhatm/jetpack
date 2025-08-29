extends Node2D

const START_SPEED = 100.0
const MAX_SPEED = 250.0
const CAMERA_OFFSET = -20
const TILE_MOVE_DISTANCE = 0.5
const TILE_REPOSITION_DISTANCE = 0.2
const SPAWN_OFFSET = 30
const SURFACE_OFFSET = 16
const SCORE_UPDATE_INTERVAL = 0.1
const TOP_SPAWN_EDGE = 140
const BOTTOW_SPAWN_EDGE = 40

@onready var ground_tile: TileMapLayer = $GroundTile
@onready var player: CharacterBody2D = $Player
@onready var camera: Camera2D = $Camera2D
@onready var sky_border: StaticBody2D = $SkyBorder
@onready var environment_timer: Timer = $EnvironmentTimer
@onready var spawn_timer: Timer = $SpawnTimer

var tree_scene = preload("res://entities/background/tree.tscn")
var bee = preload("res://entities/enemies/bee.tscn")

var speed: float = 0
var screen_size: Vector2
var score: int = 0
var score_timer: float = 0.0

func _ready():
	screen_size = get_viewport().size
	speed = START_SPEED
	_spawn_environment()
	_spawn_enemies()

func _process(delta):
	camera.global_position.x = player.global_position.x + CAMERA_OFFSET
	
	if camera.global_position.x - ground_tile.position.x > screen_size.x * TILE_MOVE_DISTANCE:
		ground_tile.position.x += screen_size.x * TILE_REPOSITION_DISTANCE
		sky_border.position.x += screen_size.x * TILE_REPOSITION_DISTANCE
	
	score_timer += delta
	
	if score_timer >= SCORE_UPDATE_INTERVAL:
		_calculate_score()
		score_timer = 0.0
		
	speed = clamp(speed, START_SPEED, MAX_SPEED)

func _spawn_environment():
	var tree = tree_scene.instantiate()
	add_child(tree)
	tree.position.x = player.position.x + screen_size.x + SPAWN_OFFSET
	tree.position.y = screen_size.y - SURFACE_OFFSET
	
	environment_timer.wait_time = randf_range(1.0, 2.0)
	environment_timer.start()
	
func _spawn_enemies():
	var bee = bee.instantiate()
	add_child(bee)
	bee.position.x = player.position.x + screen_size.x + SPAWN_OFFSET
	bee.position.y = randf_range(screen_size.y - TOP_SPAWN_EDGE, screen_size.y - BOTTOW_SPAWN_EDGE)
	
	spawn_timer.wait_time = 2
	spawn_timer.start()
	
func _calculate_score():
	var base_score = 10
	var bonus_score = max(0, (speed - START_SPEED) / 50)
	var total_score = base_score + bonus_score
	score += total_score

func _on_environment_timer_timeout() -> void:
	_spawn_environment()
	
func _on_spawn_timer_timeout() -> void:
	_spawn_enemies()
