extends Node

var can_fade_arrow=true
var can_fade_space=true
var tutorial=true
var door_opened=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_new_map_body_entered(body: Node2D) -> void:
	
	if body==$"../Hero" and tutorial:
		
		$"../Scene_transition/AnimationPlayer".play("dissolve")
		await $"../Scene_transition/AnimationPlayer".animation_finished
		$"../Hero/Camera2D".limit_left=577
		$"../Hero/Camera2D".limit_right=1728
		$"../Scene_transition/AnimationPlayer".play_backwards("dissolve")
		tutorial=false
		$"../Room_1".room_1=true
	
	


func _on_arrow_fade_body_entered(body: Node2D) -> void:
	if can_fade_arrow:
		if body==$"../Hero":
			$AnimationPlayer.play("fade_out")
			can_fade_arrow=false


func _on_space_fade_body_entered(body: Node2D) -> void:
	if can_fade_space:
		if body==$"../Hero":
			$AnimationPlayer.play("fade_out_space")
			can_fade_space=false



func _on_door_open_body_entered(body: Node2D) -> void:
	if body==$"../Hero" and not door_opened and GameData.save_data["shield_unlocked"]:
		$door/door_anim.play("door_open")
		$door/AnimationPlayer.play("open_door")
		$door_open/CollisionShape2D.disabled=true
		door_opened=true
