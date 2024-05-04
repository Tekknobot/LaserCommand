extends Sprite2D

var rng = RandomNumberGenerator.new()
var structure_saves = 0

var demolihed_count = 0
var demolished_structures = 0

var stop_laser = false
var x = 0
var barrage = false
var shots = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_node("../SaveLoad").load_score() == 0:
		$"../Control/SkinButtons/Button_1".show()
		$"../Control/BossBar".max_value = 110
		$"../Control/BossBar".value = 110
			
	if get_node("../SaveLoad").load_score() == 1:
		$"../Control/SkinButtons/Button_1".show()
		$"../Control/SkinButtons/Button_2".show()
		$"../Control/BossBar".max_value = 120
		$"../Control/BossBar".value = 120		
		$"../Control/SkinButtons/Button_0".show()
		_on_button_2_pressed()

	if get_node("../SaveLoad").load_score() == 2:
		$"../Control/SkinButtons/Button_1".show()
		$"../Control/SkinButtons/Button_2".show()		
		$"../Control/SkinButtons/Button_3".show()
		$"../Control/BossBar".max_value = 130
		$"../Control/BossBar".value = 130
		$"../Control/SkinButtons/Button_0".show()
		_on_button_3_pressed()
		
	if get_node("../SaveLoad").load_score() == 3:
		$"../Control/SkinButtons/Button_1".show()
		$"../Control/SkinButtons/Button_2".show()		
		$"../Control/SkinButtons/Button_3".show()
		$"../Control/SkinButtons/Button_4".show()
		$"../Control/BossBar".max_value = 140
		$"../Control/BossBar".value = 140
		$"../Control/SkinButtons/Button_0".show()
		_on_button_4_pressed()

	if get_node("../SaveLoad").load_score() == 4:
		$"../Control/SkinButtons/Button_1".show()
		$"../Control/SkinButtons/Button_2".show()		
		$"../Control/SkinButtons/Button_3".show()
		$"../Control/SkinButtons/Button_4".show()	
		$"../Control/SkinButtons/Button_5".show()
		$"../Control/BossBar".max_value = 150
		$"../Control/BossBar".value = 150	
		$"../Control/SkinButtons/Button_0".show()	
		_on_button_5_pressed()	
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$"../Control/Time".text = "Time: " + str(floor($"../LevelTimer".time_left))

	if $"../LevelTimer".time_left <= 100:
		$"../LaserTimer".wait_time = 3

	if $"../LevelTimer".time_left <= 90:
		$"../LaserTimer".wait_time = 3
			
	if $"../LevelTimer".time_left <= 80:
		$"../LaserTimer".wait_time = 2.5

	if $"../LevelTimer".time_left <= 70:
		$"../LaserTimer".wait_time = 2.5

	if $"../LevelTimer".time_left <= 60:
		$"../LaserTimer".wait_time = 2.0
		
	if $"../LevelTimer".time_left <= 50:
		$"../LaserTimer".wait_time = 2.0	
		
	if $"../LevelTimer".time_left <= 40:
		$"../LaserTimer".wait_time = 1.5			

	if $"../LevelTimer".time_left <= 30:
		$"../LaserTimer".wait_time = 1.4	
		
	if $"../LevelTimer".time_left <= 20:
		$"../LaserTimer".wait_time = 1.3	

	if $"../LevelTimer".time_left <= 10:
		$"../LaserTimer".wait_time = 1.2	
		
	if $"../LevelTimer".time_left <= 5:
		$"../LaserTimer".wait_time = 1.1			
	
	$"../Control/Boss".text = "BOSS " + str($"../Control/BossBar".value)
					
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and $"../Laser".laser_on == false:
				#print("Left button was clicked at ", event.position)
				#$"../Laser".draw_laser_player()
				pass
			else:
				#print("Left button was released")
				pass
		if event.button_index == MOUSE_BUTTON_RIGHT and structure_saves >= 10:
			if structure_saves != 0:
				for i in structure_saves:
					var tween: Tween = create_tween()
					var random = rng.randi_range(0, get_node("/root/Scene2D").structures.size()-1)
					tween.tween_property(get_node("/root/Scene2D").structures[random], "modulate:v", 1, 0.1).from(5)
					if get_node("/root/Scene2D").structures[random].demolished == false:
						pass
					else:
						get_node("/root/Scene2D").structures[random].get_child(0).play("default")
						#get_node("/root/Scene2D").structures[random].get_child(0).modulate = Color8(rng.randi_range(150, 255), rng.randi_range(150, 255), rng.randi_range(150, 255))	
						get_node("/root/Scene2D").structures[random].demolished = false	
						get_node("/root/Scene2D/Laser").demolished_structures -= 1
					await get_tree().create_timer(0.05).timeout
			
			structure_saves = 0	
			get_node("../Control").get_child(0).text = "Intercepts " + str(structure_saves)						
			get_node("../Control").get_child(1).text = "Demolished " + str(get_node("/root/Scene2D/Laser").demolished_structures) + " of " + str($"..".structures.size() / 4)

		if event.button_index == MOUSE_BUTTON_WHEEL_UP and get_node("../Laser").gameover == false:	
			if x >= get_node("/root/Scene2D").structures.size():
				barrage = false
				get_node("../Control/Power").text = "Power " + (str(get_node("../Hovertile").shots) + " of 10")	
				return				
			if event.pressed and get_node("/root/Scene2D").structures[x].demolished == false and barrage == true:		
				var tile_position = get_node("../TileMap").map_to_local(get_node("/root/Scene2D").structures[x].coord) + Vector2(0,0) / 2	
				get_node("/root/Scene2D").structures[x].SetLinePoints(tile_position, get_node("../Drone").position)

			x += 1
						
func _on_timer_timeout():
	if stop_laser == false:
		$"../Laser".draw_laser()
		
func _on_level_timer_timeout():
	$"../Control/CLEARED".show()
	$"../LevelTimer".stop()
	stop_laser = true	
	
	$"../SoundStream".stream = $"../SoundStream".map_sfx[10]
	$"../SoundStream".play()		

func _on_button_1_pressed():
	$"../ShaderRect".material.set("shader_parameter/lightest",Color(0.608, 0.737, 0.059))
	$"../ShaderRect".material.set("shader_parameter/light",Color(0.545, 0.675, 0.059))
	$"../ShaderRect".material.set("shader_parameter/dark",Color(0.188, 0.384, 0.188))
	$"../ShaderRect".material.set("shader_parameter/darkest",Color(0.059, 0.22, 0.059))

func _on_button_2_pressed():
	$"../ShaderRect".material.set("shader_parameter/lightest",Color(0.788, 0.757, 0.682))
	$"../ShaderRect".material.set("shader_parameter/light",Color(0.91, 0.894, 0.859))
	$"../ShaderRect".material.set("shader_parameter/dark",Color(0.608, 0.631, 0.498))
	$"../ShaderRect".material.set("shader_parameter/darkest",Color(0.306, 0.341, 0.231))

func _on_button_3_pressed():
	$"../ShaderRect".material.set("shader_parameter/lightest",Color(1, 0.867, 0.824))
	$"../ShaderRect".material.set("shader_parameter/light",Color(0.929, 0.965, 0.976))
	$"../ShaderRect".material.set("shader_parameter/dark",Color(0.514, 0.773, 0.745))
	$"../ShaderRect".material.set("shader_parameter/darkest",Color(0, 0.427, 0.467))

func _on_button_4_pressed():
	$"../ShaderRect".material.set("shader_parameter/lightest",Color(0.937, 0.137, 0.235))
	$"../ShaderRect".material.set("shader_parameter/light",Color(0.929, 0.949, 0.957))
	$"../ShaderRect".material.set("shader_parameter/dark",Color(0.553, 0.6, 0.682))
	$"../ShaderRect".material.set("shader_parameter/darkest",Color(0.169, 0.176, 0.259))
	
func _on_button_5_pressed():
	$"../ShaderRect".material.set("shader_parameter/lightest",Color(0.988, 0.749, 0.286))
	$"../ShaderRect".material.set("shader_parameter/light",Color(0.969, 0.498, 0))
	$"../ShaderRect".material.set("shader_parameter/dark",Color(0.839, 0.157, 0.157))
	$"../ShaderRect".material.set("shader_parameter/darkest",Color(0, 0.188, 0.286))	

#Random skin
func _on_button_0_pressed():
	$"../ShaderRect".material.set("shader_parameter/lightest",Color(rng.randf_range(0.80, 0.90), rng.randf_range(0.80, 0.90), rng.randf_range(0.8, 0.9)))
	$"../ShaderRect".material.set("shader_parameter/light",Color(rng.randf_range(0.40, 0.80), rng.randf_range(0.40, 0.80), rng.randf_range(0.4, 0.8)))
	$"../ShaderRect".material.set("shader_parameter/dark",Color(rng.randf_range(0.20, 0.40), rng.randf_range(0.20, 0.40), rng.randf_range(0.2, 0.4)))
	$"../ShaderRect".material.set("shader_parameter/darkest",Color(rng.randf_range(0.10, 0.20), rng.randf_range(0.10, 0.20), rng.randf_range(0.1, 0.2)))

func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/title_2d.scn")
