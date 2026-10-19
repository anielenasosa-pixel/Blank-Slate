extends Node2D


@onready var shine_package=preload("res://scenes/shine.tscn")
var destination
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().died.connect(spawn_shine)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_shine():
	for i in range(get_parent().enemy_stats.shine_count):
		var enemy_pos=get_parent().global_position
		if Global.room_boss:
			destination = Vector2(
			randf_range(enemy_pos.x-100,enemy_pos.x+100),
			randf_range(enemy_pos.y-100,enemy_pos.y+100)
			)
		else:
			destination = Vector2(
			randf_range(enemy_pos.x-20,enemy_pos.x+20),
			randf_range(enemy_pos.y-20,enemy_pos.y+20)
			)
		var shine = shine_package.instantiate()
		shine.global_position=enemy_pos
		get_tree().current_scene.add_child(shine)
		shine.call_deferred("spawn")
		var tween = shine.create_tween()
		tween.tween_property(shine,"global_position",destination,0.5)
