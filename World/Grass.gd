extends Node2D


const GrassEffect = preload("res://Effects/GrassEffect.tscn") # alt: load in create_grass_effect

func create_grass_effect():
		# instance a scene, dragged abs reference here
		var grassEffect = GrassEffect.instance()
		
		# loaded effects have to be child of grass
		#var world = get_tree().current_scene # returns the world "remote" scene
		#world.add_child(grassEffect) # set to world node's child
		get_parent().add_child(grassEffect)
		
		# set grassEffect's global pos to Grass's global pos
		grassEffect.global_position = global_position


func _on_HurtBox_area_entered(_area):
	create_grass_effect()
	queue_free()
	
	# disable hurtbox in case of repeats
