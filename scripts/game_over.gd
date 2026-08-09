extends Node

@export var hero_stats:Resource
var restart_pressed = false
var alive=true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	lost_health()


func lost_health():
	if hero_stats.health<=0 and alive:
		dead()
		alive=false

func dead():
	if hero_stats.health<=0:
		Global.pause = true
		$AnimationPlayer.play("Game Ove")
		await $AnimationPlayer.animation_finished
		restart_pressed = true



func _on_button_pressed() -> void:
	if restart_pressed:
		restart_pressed = false
		$AnimationPlayer.play_backwards("Game Ove")
		await $AnimationPlayer.animation_finished
		Global.pause = false
		hero_stats.restore()
		Global.tutorial=true
		Global.room_1 = false
		Global.room_2 =false
		Global.shine_count=0
		get_tree().reload_current_scene()
