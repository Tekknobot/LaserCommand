extends Sprite2D

var rng = RandomNumberGenerator.new()
var structure_saves = 0

var demolihed_count = 0
var demolished_structures = 0

var stop_laser = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

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
		if event.button_index == MOUSE_BUTTON_RIGHT:
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
						
func _on_timer_timeout():
	if stop_laser == false:
		$"../Laser".draw_laser()
		
func _on_level_timer_timeout():
	$"../Control/CLEARED".show()
	$"../LevelTimer".stop()
	stop_laser = true	
	
	$"../SoundStream".stream = $"../SoundStream".map_sfx[10]
	$"../SoundStream".play()		
