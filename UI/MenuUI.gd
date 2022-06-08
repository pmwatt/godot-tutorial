extends MenuButton


var popup

func _ready():
	popup = get_popup()
	popup.connect("id_pressed", self, "_on_id_pressed")
	
func _on_id_pressed(id):
	match (id):
		# both of these don't reset the game
		# e.g. stuck at 0hp, white shaded sprite while getting hit
		# grass got reset
		
		0: # restart
			get_tree().reload_current_scene()
		1: # quit
			get_tree().change_scene("res://UI/Menu.tscn")
