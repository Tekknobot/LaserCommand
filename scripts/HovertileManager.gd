extends Sprite2D

var rng = RandomNumberGenerator.new()

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
			for i in $"..".structures.size():
				var tween: Tween = create_tween()
				tween.tween_property(get_node("/root/Scene2D").structures[i], "modulate:v", 1, 0.1).from(5)
				get_node("/root/Scene2D").structures[i].get_child(0).play("default")
				get_node("/root/Scene2D").structures[i].get_child(0).modulate = Color8(rng.randi_range(150, 255), rng.randi_range(150, 255), rng.randi_range(150, 255))	
				await get_tree().create_timer(0.05).timeout

func _on_timer_timeout():
	$"../Laser".draw_laser()
	
