extends Node

var help_needed=true
@onready var label = $Label
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	help_text()
	



		



func help_text():
	if Global.room_1 and help_needed and not GameData.save_data["tips_spoken"]:
		help_needed=false
		$AnimationPlayer.play("open_help")
		await $AnimationPlayer.animation_finished
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
		$AnimationPlayer.play_backwards("open_help")
		await $AnimationPlayer.animation_finished
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
		
