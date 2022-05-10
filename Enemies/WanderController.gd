extends Node2D


export(int) var wander_range

onready var start_position = global_position # constant, for e.g. bat
onready var target_position = global_position # changes, relative to start_position

onready var timer = $Timer

func _ready():
	update_target_position()

func update_target_position():
	var target_vector = Vector2(rand_range(-wander_range, wander_range), rand_range(-wander_range, wander_range))
	target_position = start_position + target_vector

func get_time_left():
	return timer.time_left

func start_wander_timer(duration):
	timer.start(duration)

func _on_Timer_timeout():
	update_target_position()
