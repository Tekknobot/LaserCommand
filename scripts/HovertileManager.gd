extends Sprite2D

var rng = RandomNumberGenerator.new()
var structure_saves = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


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
					get_node("/root/Scene2D").structures[random].get_child(0).play("default")
					get_node("/root/Scene2D").structures[random].get_child(0).modulate = Color8(rng.randi_range(150, 255), rng.randi_range(150, 255), rng.randi_range(150, 255))	
					await get_tree().create_timer(0.05).timeout
			
			structure_saves = 0	
			get_node("../Control").get_child(0).text = "Intercepts " + str(structure_saves)	

func _on_timer_timeout():
	$"../Laser".draw_laser()
	
