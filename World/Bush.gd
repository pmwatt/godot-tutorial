extends StaticBody2D


const BushEffect = preload("res://Effects/BushEffect.tscn")

func create_bush_effect():
	# instance
	var bushEffect = BushEffect.instance()
	
	# add child to every bushes
	var world = get_tree().current_scene
	world.add_child(bushEffect)
	bushEffect.global_position = global_position

func _on_HurtBox_area_entered(_area):
	create_bush_effect() # Replace with function body.
