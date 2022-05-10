extends Area2D

const HitEffect = preload("res://Effects/HitEffect.tscn")

var invincible = false setget set_invincible

onready var timer = $Timer

signal invincibility_started
signal invincibility_ended

func set_invincible(value):
	invincible = value # won't call setter because there's no self
	if invincible:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

func create_hit_effect():
	var effect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position


func _on_Timer_timeout():
	self.invincible = false # calls getter because there's self


func _on_HurtBox_invincibility_started():
	#monitorable = false # deactivates hurtbox, during physics process, not allowed
	set_deferred("monitoring", false)

func _on_HurtBox_invincibility_ended():
	monitoring = true # on timer, not physics
