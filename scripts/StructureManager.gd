extends Area2D

@export var structure_type: String
@export var demolished_texture: Texture2D
@onready var Map = $TileMap

var tile_pos
var coord
var mouse_pos
var unit_pos

var demolished = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):	
	var unit_global_position = self.position
	unit_pos = get_node("../TileMap").local_to_map(unit_global_position)
	get_node("../TileMap").astar_grid.set_point_solid(unit_pos, true)
	
	self.tile_pos = get_node("../TileMap").local_to_map(self.position)
	# Z index layering
	self.z_index = (tile_pos.x + tile_pos.y) + 1
	
	self.coord = tile_pos

func _unhandled_input(event):
	mouse_pos = get_global_mouse_position()
	mouse_pos.y += 8
	tile_pos = get_node("../TileMap").local_to_map(mouse_pos)
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:		
			if event.pressed and tile_pos == unit_pos and get_node("../Laser").laser_on == true and demolished == false:
				get_child(0).play("default")
				#get_child(0).modulate = Color8(255, 255, 255) 			
				get_node("../Line2D").hide()
				get_node("../Laser").laser_can = false
				$"../SoundStream".stream = $"../SoundStream".map_sfx[6]
				$"../SoundStream".play()					
	#pass	
