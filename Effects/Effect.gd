extends AnimatedSprite



func _ready():
	# object that has the signal(signal it's connected to, object that have the function, function that we're connecting to)
	connect("animation_finished", self, "_on_animation_finished")
	frame = 0
	play("animate")

func _on_animation_finished():
	queue_free()
