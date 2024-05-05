extends Node2D

@export var Map: TileMap
@export var node2D: Node2D

var point1 : Vector2 = Vector2(0, 0)
var width : int = 2
var color : Color = Color.RED
@export var antialiasing : bool = true

@onready var line_2d = $"../Line2D"
@onready var scene2d = $".."

var laser_a = Vector2(0,0)
var laser_b = Vector2(0,0)

var explosion = preload("res://scenes/vfx/explosion.scn")
var blood = preload("res://scenes/vfx/blood.scn")

var laser_on = false
var rng = RandomNumberGenerator.new()

var x = 0
var laser_can = true
var laser_pos
var laser_map

var demolihed_count = 0
var demolished_structures = 0
var gameover = false

var wins = 0
var t = 0.0

func _ready():
	laser_a = Vector2(0,-500)
	wins = get_node("../SaveLoad").load_score()

func _physics_process(delta):
	t += delta * 0.4

func draw_laser():
	laser_can = true
	laser_on = true
	$"../SoundStream".stream = $"../SoundStream".map_sfx[3]
	$"../SoundStream".play()	

	var my_random_x = rng.randi_range(1, 14)
	var my_random_y = rng.randi_range(1, 14)
	var struct_size = scene2d.structures.size()
	laser_pos = Map.map_to_local(scene2d.structures[rng.randi_range(0, struct_size-1)].coord) + Vector2(0,0) / 2
	laser_map = Map.local_to_map(laser_pos)
								
	#get_node("../TileMap").hovertile.hide()
	line_2d.show()		
	line_2d.set_joint_mode(2)
	var curve := Curve2D.new()
	var emitter = Vector2(0,-500)
	var end_point = Vector2(laser_pos.x, laser_pos.y-8)
	
	curve.add_point(emitter, Vector2.ZERO, Vector2(0,0))
	curve.add_point(end_point, Vector2(0,0), Vector2.ZERO)
	line_2d.points = curve.get_baked_points()

	var blood_instance = blood.instantiate()
	var blood_position = Vector2(laser_pos.x, laser_pos.y-8)
	get_parent().add_child(blood_instance)
	blood_instance.position = blood_position
	blood_instance.emitting = true	
	var struct_pos = get_node("../TileMap").local_to_map(Vector2(laser_pos.x, laser_pos.y-8))
	blood_instance.z_index = (struct_pos.x + struct_pos.y) + 4
	
	for i in 8:
		line_2d.set_antialiased(false)
		line_2d.set_width(1)	
		line_2d.set_default_color(Color.WHITE_SMOKE)	
		await get_tree().create_timer(0.05).timeout
		line_2d.set_width(2)
		line_2d.set_default_color(Color.RED)
		for j in $"..".structures.size():
			if laser_pos == $"..".structures[j].position:	
				var tween: Tween = create_tween()
				tween.tween_property(get_node("/root/Scene2D").structures[j], "modulate:v", 1, 0.20).from(5)					
		
		await get_tree().create_timer(0.05).timeout

	if laser_can == true:
		var explosion_instance = explosion.instantiate()
		var explosion_position = Vector2(laser_pos.x, laser_pos.y-8)
		var tile_pos = get_node("../TileMap").local_to_map(Vector2(laser_pos.x, laser_pos.y-8))
		get_parent().add_child(explosion_instance)
		explosion_instance.position = explosion_position
		explosion_instance.z_index = (tile_pos.x + tile_pos.y) + 4
		
		
		for i in $"..".structures.size():
			if laser_pos == $"..".structures[i].position and $"..".structures[i].demolished == false:
				get_node("/root/Scene2D").structures[i].get_child(0).play("demolished")
				get_node("/root/Scene2D").structures[i].get_child(0).modulate = Color8(255, 255, 255) 	
				get_node("/root/Scene2D").structures[i].demolished = true
				
				demolished_structures += 1				
				get_node("../Control").get_child(1).text = "Demolished "+ str(demolished_structures) + " of " + str($"..".structures.size() / 5)
				
		if get_node("/root/Scene2D/Laser").demolished_structures >= $"..".structures.size() / 5 and $"../Hovertile".stop_laser != true:
			$"../Control/GAMEOVER".show()	
			$"../MapMusicStream".stream = $"../MapMusicStream".map_music[1]
			$"../MapMusicStream".play()
			
			$"../LevelTimer".paused = true	
			$"../Hovertile".stop_laser = true	

	#Boss loss	
	if $"../Control/BossBar".value <= 0 and gameover == false:
		gameover = true
		$"../Control/CLEARED".show()
		$"../LevelTimer".paused = true	
		$"../MapMusicStream".playing = true	
		get_node("../Hovertile").stop_laser = true	
		
		wins += 1
		if wins >= 16:
			gameover = true
			return
		else:	
			get_node("../SaveLoad").save_score(wins)
		
		
	laser_on = false		
	line_2d.hide()	
	get_node("../TileMap").hovertile.show()
	
func intercepted_laser():
	laser_can = true
	laser_on = true
	$"../SoundStream".stream = $"../SoundStream".map_sfx[3]
	$"../SoundStream".play()	

	var my_random_x = rng.randi_range(1, 14)
	var my_random_y = rng.randi_range(1, 14)
	var empty_size = scene2d.empty_tiles.size()
	laser_pos = Map.map_to_local(scene2d.empty_tiles[rng.randi_range(0, empty_size-1)]) + Vector2(0,0) / 2
	laser_map = Map.local_to_map(laser_pos)
								
	#get_node("../TileMap").hovertile.hide()
	line_2d.show()		
	line_2d.set_joint_mode(2)
	var curve := Curve2D.new()
	var emitter = Vector2(0,-500)
	var end_point = Vector2(laser_pos.x, laser_pos.y-8)
	
	curve.add_point(emitter, Vector2.ZERO, Vector2(0,0))
	curve.add_point(end_point, Vector2(0,0), Vector2.ZERO)
	line_2d.points = curve.get_baked_points()

	#var blood_instance = blood.instantiate()
	#var blood_position = Vector2(laser_pos.x, laser_pos.y-8)
	#get_parent().add_child(blood_instance)
	#blood_instance.position = blood_position
	#blood_instance.emitting = true	
	#var struct_pos = get_node("../TileMap").local_to_map(Vector2(laser_pos.x, laser_pos.y-8))
	#blood_instance.z_index = (struct_pos.x + struct_pos.y) + 4
	
	for i in 8:
		line_2d.set_antialiased(false)
		line_2d.set_width(1)	
		line_2d.set_default_color(Color.WHITE_SMOKE)	
		await get_tree().create_timer(0.05).timeout
		line_2d.set_width(2)
		line_2d.set_default_color(Color.RED)
		for j in $"..".structures.size():
			if laser_pos == $"..".structures[j].position:	
				var tween: Tween = create_tween()
				tween.tween_property(get_node("/root/Scene2D").structures[j], "modulate:v", 1, 0.20).from(5)					
		
		await get_tree().create_timer(0.05).timeout

	#var explosion_instance = explosion.instantiate()
	#var explosion_position = Vector2(laser_pos.x, laser_pos.y-8)
	#var tile_pos = get_node("../TileMap").local_to_map(Vector2(laser_pos.x, laser_pos.y-8))
	#get_parent().add_child(explosion_instance)
	#explosion_instance.position = explosion_position
	#explosion_instance.z_index = (tile_pos.x + tile_pos.y) + 4
	
	
	#for i in $"..".structures.size():
		#if laser_pos == $"..".structures[i].position and $"..".structures[i].demolished == false:
			#get_node("/root/Scene2D").structures[i].get_child(0).play("demolished")
			#get_node("/root/Scene2D").structures[i].get_child(0).modulate = Color8(255, 255, 255) 	
			#get_node("/root/Scene2D").structures[i].demolished = true
			#
			#demolished_structures += 1				
			#get_node("../Control").get_child(1).text = "Demolished "+ str(demolished_structures) + " of " + str($"..".structures.size() / 4)
			#
	#if get_node("/root/Scene2D/Laser").demolished_structures >= $"..".structures.size() / 4 and $"../Hovertile".stop_laser != true:
		#$"../Control/GAMEOVER".show()	
		#$"../MapMusicStream".stream = $"../MapMusicStream".map_music[1]
		#$"../MapMusicStream".play()
		#
		#$"../LevelTimer".paused = true	
		#$"../Hovertile".stop_laser = true	

	#Boss loss	
	if $"../Control/BossBar".value <= 0:
		$"../Control/CLEARED".show()
		$"../LevelTimer".paused = true	
		$"../MapMusicStream".playing = true	
		get_node("../Hovertile").stop_laser = true	
		gameover = true
		wins += 1
		if wins >= 11:
			return
		else:	
			get_node("../SaveLoad").save_score(wins)

	#laser_on = false		
	#line_2d.hide()	
	get_node("../TileMap").hovertile.show()
	
