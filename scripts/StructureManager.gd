extends Area2D

@export var structure_type: String
@export var demolished_texture: Texture2D
@onready var Map = $TileMap

var seeker = preload("res://scenes/projectiles/projectile.scn")

var tile_pos
var coord
var mouse_pos
var unit_pos

var demolished = false
var structure_saves = 0
var middle = false
var x = 0
var shots = 0

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
			if event.pressed and tile_pos == unit_pos and get_node("../Laser").laser_on == true and demolished == false and tile_pos == get_node("../Laser").laser_map:     
				get_child(0).play("default")
				#get_child(0).modulate = Color8(255, 255, 255) 			
				get_node("../Line2D").hide()
				get_node("../Laser").laser_can = false
				$"../SoundStream".stream = $"../SoundStream".map_sfx[6]
				$"../SoundStream".play()		
				
				get_node("../Hovertile").structure_saves += 1	
				get_node("../Control").get_child(0).text = "Intercepts " + str(get_node("../Hovertile").structure_saves)	
										
				return
					
		if event.button_index == MOUSE_BUTTON_LEFT and get_node("../Laser").gameover == false and demolished == false:		
			if event.pressed and tile_pos == unit_pos and middle == false:
				middle = true
				var tile_position = get_node("../TileMap").map_to_local(tile_pos) + Vector2(0,0) / 2
				
				if get_node("../Control/Power").text == "Power Full":
					return			
				elif get_node("../Hovertile").shots >= 19 and get_node("../Hovertile").barrage == false:
					get_node("../Hovertile").x = 0				
					get_node("../Hovertile").shots = 0
					get_node("../Control/Power").text = "Power Full"
					get_node("../Hovertile").barrage = true
				elif get_node("../Hovertile").shots <= 19:
					get_node("../Hovertile").shots += 1	
					get_node("../Control/Power").text = "Power " + (str(get_node("../Hovertile").shots) + " of 20")		
													
				await SetLinePoints(tile_position, get_node("../Drone").position)
						
				
func SetLinePoints(a: Vector2, b: Vector2):
	var _a = get_node("../TileMap").local_to_map(a)
	var _b = get_node("../TileMap").local_to_map(b)		
	
	var seeker_instance = seeker.instantiate()
	var seeker_position = get_node("../TileMap").map_to_local(_a) + Vector2(0,0) / 2
	seeker_instance.set_name("seeker")
	get_parent().add_child(seeker_instance)	

	$"../SoundStream".stream = $"../SoundStream".map_sfx[7]
	$"../SoundStream".play()	
	
	seeker_instance.position = a
	seeker_instance.z_index = seeker_instance.position.x + seeker_instance.position.y
	var tween: Tween = create_tween()
	tween.tween_property(seeker_instance, "position", b, 4).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)	
	await get_tree().create_timer(4).timeout		

	var explosion = preload("res://scenes/vfx/explosion.scn")
	var explosion_instance = explosion.instantiate()
	var explosion_position = get_node("../TileMap").map_to_local(_b) + Vector2(0,0) / 2
	explosion_instance.set_name("explosion")
	get_parent().add_child(explosion_instance)
	explosion_instance.position = explosion_position	
	explosion_instance.position.y -= 16
	explosion_instance.z_index = (_b.x + _b.y) + 1

	$"../SoundStream".stream = $"../SoundStream".map_sfx[8]
	$"../SoundStream".play()	
	get_node("../Camera2D").shake(1, 50, 1)
	$"../Control/BossBar".value -= 1
	var tween2: Tween = create_tween()
	tween2.tween_property($"../Control/BossBar", "modulate:v", 1, 0.20).from(5)
	middle = false
