extends Node2D

var save_path = "res://score.save"
var highscore = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#save_score(5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func save_score(highscore):
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(highscore)
	
func load_score():
	if FileAccess.file_exists(save_path):
		#print("file found")
		var file = FileAccess.open(save_path, FileAccess.READ)
		highscore = file.get_var()
	else:
		print("file not found")
		highscore = 0	
		
	return highscore			


func _on_next_button_pressed():
	get_tree().reload_current_scene()
