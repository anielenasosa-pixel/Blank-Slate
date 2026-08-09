extends Node2D

@export var float_speed: float = 3.0     # How fast it breathes
@export var float_amount: float = 5.0    # How high it floats up/down
@export var rotation_speed: float = 8.0  # How fast it orbits to the other side
@export var sway_lag: float = 0.1        # How much it drags behind when moving

var time: float = 0.0
var target_scale_x: float = 1.0
@onready var original_y: float = position.y

func _process(delta: float) -> void:
	time += delta
	
	# 1. Get player velocity from the parent node
	var player_vel = get_parent().velocity
	
	# 2. Determine which side the sword should face based on movement
	if (get_global_mouse_position()-get_parent().position).x > 0:
		target_scale_x = 1.0   # Face right
		position=Vector2(19,11)
	elif(get_global_mouse_position()-get_parent().position).x < 0:
		target_scale_x = -1.0  # Face left
		position=Vector2(-19,11)
	
	# 3. Smoothly interpolate the scale.x to orbit around the player
	# This creates a beautiful "swinging around the body" arc effect
	scale.x = target_scale_x
	
	# 4. Handle the Idle Float (Up and down breathing)
	var target_y = original_y + (sin(time * float_speed) * float_amount)
	
	# 5. Add inertia lag (Swaying slightly behind when moving up/down)
	target_y -= player_vel.y * sway_lag
	
	# Smoothly apply the vertical floating/swaying
	position.y = lerp(position.y, target_y, 10.0 * delta)
	swing()
	invisible_bubble()

func invisible_bubble():
	if not Global.pause:
		var max_position = 100
		var hero_position = get_parent().global_position
		var mouse_pos = get_global_mouse_position()
		var offset = mouse_pos - hero_position
		
		if offset.length() > max_position:
			offset = offset.normalized() * max_position
		
		$RigidBody2D.global_position = hero_position + offset

func swing():
	if Input.is_action_just_pressed("click"):
		$RigidBody2D/AnimationPlayer.play("swing")
		await $RigidBody2D/AnimationPlayer.animation_finished
		$RigidBody2D/AnimationPlayer.play("sword_return")
	
	''' if Input.is_action_just_pressed("click"):
		if direction.x>0:
			$RigidBody2D/AnimationPlayer.play("swing_left")
			await $RigidBody2D/AnimationPlayer.animation_finished
			$RigidBody2D/AnimationPlayer.play_backwards("swing_left")
		elif direction.x>0:
			$RigidBody2D/AnimationPlayer.play("swing_right")
			await $RigidBody2D/AnimationPlayer.animation_finished
			$RigidBody2D/AnimationPlayer.play_backwards("swing_right") '''
