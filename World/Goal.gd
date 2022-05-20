extends Node2D




onready var hitMe = $HitMe


func _on_Goal_mouse_exited():
	hitMe.visible = false

func _on_Goal_mouse_entered():
	hitMe.visible = true
