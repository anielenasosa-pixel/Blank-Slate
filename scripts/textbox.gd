extends Control



@onready var label=$text
@onready var opt_1= $opt_1
@onready var opt_2= $opt_2
@onready var opt_1_button= $"textbox/opt 1"
@onready var opt_2_button= $"textbox/opt 2"
signal choice_made(button_id: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	Events.talking.connect(text_box)
	opt_1_button.pressed.connect(func(): choice_made.emit(1))
	opt_2_button.pressed.connect(func(): choice_made.emit(2))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	buttons()
	
	
	
func text_box(text_num):
	Global.pause=true
	visible=true
	label.visible=false
	
	$textbox/AnimationPlayer.play("up")
	await $textbox/AnimationPlayer.animation_finished
	
	label.visible=true
	label.autowrap_mode = TextServer.AUTOWRAP_WORD

	if text_num == 1:
		label.visible_characters=0
		label.text =  "My Lord! I have found you at long last. I desperately require your aid!"
		await typewriter() 
		show_options()
		opt_1.text="Who are you?"
		opt_2.text="My Lord..?"
		var choice = await wait_for_option()
		if choice==1:
			hide_options()
			label.visible_characters=0
			label.text =  "You do not remember me?"
			await typewriter() 
			await wait_for_click()
			label.visible_characters=0
			label.text = "It seems the effects of the spell were far stronger than we could have imagined."
			await typewriter()
			await wait_for_click()
			label.visible_characters=0
			label.text = "But that is of no consequence. In answer to your question, milord, I am Globo. One of the six Primaries."
			await typewriter()
			opt_1.text="The six Primaries?"
			opt_2.text="The. six. what."
			show_options()
			choice = await wait_for_option()
#=================================================================
			if choice==1 or choice ==2:
				hide_options()
				label.visible_characters=0
				label.text="Six heralds formerly sworn to protect the King at all costs."
				await typewriter() 
				opt_1.text="..Formerly?"
				opt_2.text="What King?"
				show_options()
				choice = await wait_for_option()
				if choice==1:
					hide_options()
					label.visible_characters=0
					label.text="It’s a well-known story by now, lad. But since you don’t seem to know it, let me spin the tale for you one final time…"
					await typewriter() 
					await wait_for_click()
					label.visible_characters=0
				elif choice==2:
					hide_options()
					label.visible_characters=0
					label.text="Oh, for canvas’ sake. It’s worse than I thought."
					await typewriter() 
					await wait_for_click()
					label.visible_characters=0
					label.text="The king is the ruler of the land we currently stand in. His story…well, I figure its best we start at the beginning."
					await typewriter() 
					await wait_for_click()
					label.visible_characters=0
		elif choice==2:
			hide_options()
			label.visible_characters=0
			label.text =  "No, no! You’re the lord, not me! I’m merely one of the six Primaries!"
			await typewriter() 
			opt_1.text="The six Primaries?"
			opt_2.text="The. six. what."
			show_options()
			choice = await wait_for_option()
	#=================================================================
			if choice==1 or choice ==2:
				hide_options()
				label.visible_characters=0
				label.text="Six heralds formerly sworn to protect the King at all costs."
				await typewriter() 
				opt_1.text="..Formerly?"
				opt_2.text="What King?"
				show_options()
				choice= await wait_for_option()
				if choice==1:
					hide_options()
					label.visible_characters=0
					label.text="It’s a well-known story by now, lad. But since you don’t seem to know it, let me spin the tale for you one final time…"
					await typewriter() 
					await wait_for_click()
					label.visible_characters=0
				elif choice==2:
					hide_options()
					label.visible_characters=0
					label.text="Oh, for canvas’ sake. It’s worse than I thought."
					await typewriter() 
					await wait_for_click()
					label.visible_characters=0
					label.text="The king is the ruler of the land we currently stand in. His story…well, I figure its best we start at the beginning."
					await typewriter() 
					await wait_for_click()
					label.visible_characters=0
			
		label.text="*message from the developers*...the story isnt done yet so moving on"
		await typewriter() 
		await wait_for_click()
		label.visible_characters=0
		label.text="I'll help you along your journey"
		await typewriter() 
		await wait_for_click()
		label.visible_characters=0
		label.text = "Just click the arrow keys or asdw to move around"
		await typewriter() 
		await wait_for_click()
		label.visible_characters=0
		label.text = "I also remember you to be quite agile, so use that to your advantage"
		await typewriter() 
		await wait_for_click()
		label.visible_characters=0
		label.text = "When presented witha sticky situation click the  'space bar'  to dash away quickly"
		await typewriter() 
		await wait_for_click()
		label.visible_characters=0
		label.text = "And to provide some extra support I will bestow upon you my power of the shield"
		await typewriter() 
		await wait_for_click()
		label.visible_characters=0
		label.text = "Just click  'e'  when you're ready for me to appear"
		await typewriter() 
		await wait_for_click()
		label.visible_characters=0
		label.text = "Well goodluck and please help us!!"
			
			
			
		label.visible_characters=0
		$textbox/AnimationPlayer.play_backwards("up")
		await $textbox/AnimationPlayer.animation_finished
		$"../../room_container/tutorial".get_child(2).go_inside()
		await $"../../room_container/tutorial".get_child(2).go_inside()
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
		
func wait_for_option():
	await get_tree().create_timer(0.05).timeout # Small buffer to prevent instant click skips
	var button_id = await choice_made
	return button_id

func hide_options():
	$textbox/opt_1TEXT.visible=false
	$textbox/opt_2TEXT.visible=false
	opt_1.visible=false
	opt_2.visible=false
	opt_1_button.visible=false
	opt_2_button.visible=false

func show_options():
	$textbox/opt_1TEXT.visible=true
	$textbox/opt_2TEXT.visible=true
	opt_1.visible=true
	opt_2.visible=true
	opt_1_button.visible=true
	opt_2_button.visible=true
	
func buttons():
	if $"textbox/opt 1".is_hovered():
		$textbox/opt_1TEXT.modulate = Color(0.7, 0.25, 0.1)
		opt_1.add_theme_color_override("font_color", Color.WHITE)
	elif $"textbox/opt 2".is_hovered():
		$textbox/opt_2TEXT.modulate = Color(0.7, 0.25, 0.1)
		opt_2.add_theme_color_override("font_color", Color.WHITE)
	else:
		$textbox/opt_1TEXT.modulate = Color.WHITE
		$textbox/opt_2TEXT.modulate = Color.WHITE
		opt_1.add_theme_color_override("font_color", Color.from_string("#802400", Color.WHITE))
		opt_2.add_theme_color_override("font_color", Color.from_string("#802400", Color.WHITE))
