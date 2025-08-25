extends Node2D

@export var section_width: float = 240.0

@onready var ground_tile: TileMapLayer = $GroundTile
@onready var player: CharacterBody2D = $Player
@onready var camera: Camera2D = $Camera2D
@onready var sky_border: StaticBody2D = $SkyBorder

const START_SPEED = 100.0
const MAX_SPEED = 250.0
const CAMERA_OFFSET = -20
const TILE_MOVE_DISTANCE = 0.5
const TILE_REPOSITION_DISTANCE = 0.2

var speed: float = 0

func _ready():
	speed = START_SPEED

func _process(delta):
	camera.global_position.x = player.global_position.x + CAMERA_OFFSET
	
	if camera.global_position.x - ground_tile.position.x > section_width * TILE_MOVE_DISTANCE:
		ground_tile.position.x += section_width * TILE_REPOSITION_DISTANCE
		sky_border.position.x += section_width * TILE_REPOSITION_DISTANCE    
