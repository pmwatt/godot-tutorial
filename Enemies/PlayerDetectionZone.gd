extends Area2D

var player = null


func can_see_player():
	return player != null


func _on_PlayerDetectionZone_body_entered(body):
	player = body # body entered i.e. player entered


func _on_PlayerDetectionZone_body_exited(_body):
	player = null # body exited i.e. player exited
