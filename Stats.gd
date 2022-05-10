extends Node

# export as script variables
export(int) var max_health = 4 setget set_max_health # just by default; global var for all nodes to access Player's health; enemy nodes inherit this
var health = max_health setget set_health # whenever health gets reassigned, calls set_health
# setget <setter>, <getter>

signal no_health # going up against the tree height
signal health_changed(value) # value that health changed to
signal max_health_changed(value)

func set_max_health(value):
	max_health = max(value, 1)
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)

func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")

func _ready():
	self.health = max_health
