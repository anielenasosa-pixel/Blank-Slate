extends Node2D

@onready var DB_package= preload("res://scenes/dark_blob.tscn")
@onready var WP_package= preload("res://scenes/wah_pt.tscn")
@onready var WPF_package= preload("res://scenes/fire.tscn")
@onready var DW_package= preload("res://scenes/damian.tscn")
var spawn_enemy_1=false
var spawn_enemy_2=false
var random_pos
#THIS DOESNT ACTUALLY WORK
@export_range(0,100) var DB_percent:int
@export_range(0,100) var WP_percent:int
@export_range(0,100) var DW_percent:int

@export var room:String
var enemies = EnemyManager.enemies

@onready var hero = $Hero
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.kill_all.connect(kill_all)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	spawn_an_enemy_1()


func spawn_an_enemy_1():
	if Global.pause:
		return
	if spawn_enemy_1:
		if (room == "room_1" and Global.room_1):
			random_pos = Vector2(
				randf_range(658,1653),
				randf_range(-234,234)
			)
		elif (room == "room_2" and Global.room_2):
			random_pos = Vector2(
				randf_range(1776,2836),
				randf_range(-234,234)
			)
		each_spawn()
			
func each_spawn():
	var enemy_generator = randi() % 100 + 1
	if enemy_generator<=DW_percent: 
		spawn_enemy_1=false
		var DW= DW_package.instantiate()
		DW.position=random_pos
		DW.hero=hero
		get_tree().current_scene.add_child(DW)
		enemies.append(DW)
	elif enemy_generator<=WP_percent:
		
		spawn_enemy_1=false
		var WP= WP_package.instantiate()
		WP.position=random_pos
		WP.hero=hero
		get_tree().current_scene.add_child(WP)
		enemies.append(WP)
		
	elif enemy_generator<= DB_percent:
		spawn_enemy_1=false
		var DB= DB_package.instantiate()
		DB.position=random_pos
		DB.hero=hero
		get_tree().current_scene.add_child(DB)
		enemies.append(DB)





func _on_spawner_1_timeout() -> void:
	spawn_enemy_1=true

func kill_all():
	await get_tree().create_timer(0.5).timeout
	if room=="room_1" and Global.room_1==false:
		EnemyManager.enemies.clear()
		for enemy in get_tree().get_nodes_in_group("enemies"):
			enemy.queue_free()
	elif room=="room_2" and Global.room_2==false:
		EnemyManager.enemies.clear()
		for enemy in get_tree().get_nodes_in_group("enemies"):
			enemy.queue_free()
