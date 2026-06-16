extends Node

var room_1=false
var door_open=true
var door_2_open=false
var help_needed=true
@onready var label = $"../Scene_transition/helpful tips/Label"
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	help_text()
	door_1()

func door_1():
	if room_1 and door_open:
		await get_tree().create_timer(1.0).timeout
		$door_1/door_anim.play_backwards("door_open")
		$door_1/AnimationPlayer.play_backwards("open_door")
		door_open=false
		



func help_text():
	if room_1 and help_needed and not GameData.save_data["tips_spoken"]:
		help_needed=false
		$"../Scene_transition/helpful tips/AnimationPlayer".play("open_help")
		await $"../Scene_transition/helpful tips/AnimationPlayer".animation_finished
		Global.pause=true
		label.visible_characters=0
		label.text =  "Welcome to an arena..."
		await typewriter() 
		await wait_for_click()
		label.visible_characters=0
		label.text =  "Here you must defeat enemies to obtain thier hidden orb of light"
		await typewriter() 
		await wait_for_click()
		label.visible_characters=0
		label.text =  "Collect enough and you will be able to go onto the next arena"
		await typewriter() 
		await wait_for_click()
		label.visible_characters=0
		label.text =  "Orbs are the currency here, feel free to return to this arena any time you need more orbs"
		await typewriter() 
		await wait_for_click()
		label.visible_characters=0
		label.visible_characters=0
		label.text =  "I see you have the prized sword, swing it around with you mouse to attack enemies in your way"
		await typewriter() 
		await wait_for_click()
		label.visible_characters=0
		label.text =  "I wish you the best off luck...My Lord"
		await typewriter() 
		await wait_for_click()
		$"../Scene_transition/helpful tips/AnimationPlayer".play_backwards("open_help")
		await $"../Scene_transition/helpful tips/AnimationPlayer".animation_finished
		GameData.save_data["tips_spoken"] = true
		GameData.save_game()
		Global.pause=false
		
func typewriter():
	for i in range(label.text.length()):
		await get_tree().create_timer(0.0).timeout
		label.visible_characters += 1
	
		
func wait_for_click():
	while true:
		if Input.is_action_just_pressed("click"):
			break
		await get_tree().process_frame
		
		

		


func _on_door_open_body_entered(body: Node2D) -> void:
	if body == $"../Hero" and room_1 and Global.shine_count>=20 and not door_2_open:
		await get_tree().create_timer(1.0).timeout
		$door_2/door_anim.play("door_open")
		$door_2/AnimationPlayer.play("open_door")
		door_2_open = true
		




func _on_new_map_body_entered(body: Node2D) -> void:
	if body==$"../Hero" and room_1:
		$"../Scene_transition/AnimationPlayer".play("dissolve")
		await $"../Scene_transition/AnimationPlayer".animation_finished
		$"../Hero/Camera2D".limit_left=1728
		$"../Hero/Camera2D".limit_right=2879
		$"../Scene_transition/AnimationPlayer".play_backwards("dissolve")
		room_1=false
		$"../Room_2".room_2=true
