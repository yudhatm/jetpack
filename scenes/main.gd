extends Node2D

@export var scroll_speed: float = 50.0
@export var section_width: float = 240.0
var tilemap_sections = []

@onready var ground_tile: TileMapLayer = $GroundTile

func _ready():
	var original_tilemap = ground_tile  # Make sure this path is correct
	
	original_tilemap.position.x = 0
	tilemap_sections.append(original_tilemap)
	
	# Create duplicates
	for i in range(1, 3):
		var section = original_tilemap.duplicate()
		section.position.x = section_width * i
		add_child(section)
		tilemap_sections.append(section)
		print("Section ", i, " position: ", section.position.x)

func _process(delta):
	for i in range(tilemap_sections.size()):
		var section = tilemap_sections[i]
		section.position.x -= scroll_speed * delta
		
		if section.position.x <= -section_width:
			section.position.x += section_width * tilemap_sections.size()
