extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $Button.is_hovered():
		$button_texture.frame=1
	elif $Button.pressed:
		$button_texture.frame=0
	else:
		$button_texture.frame=2
		







func _on_button_pressed() -> void:
	#GameData.delete_save()
	GameData.load_game()
	get_tree().change_scene_to_file("res://scenes/main_game.tscn")
