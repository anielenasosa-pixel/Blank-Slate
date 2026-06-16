extends Node2D

@onready var zombie= preload ("res://scenes/zombie.tscn")

# Called when the node enters the scene tree for the first time.



func _on_timer_timeout() -> void:
	var zombieee= zombie.instantiate()
	zombieee.position=position
	get_tree().root.add_child(zombieee)
