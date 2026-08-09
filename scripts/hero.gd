extends CharacterBody2D


#for spawner
@onready var DB_package= preload("res://scenes/dark_blob.tscn")
@onready var PE_package= preload("res://scenes/projectile_enemy.tscn")
@onready var WP_package= preload("res://scenes/wah_pt.tscn")
@onready var DW_package= preload("res://scenes/damian.tscn")
var spawn_enemy_1=false
var spawn_enemy_2=false

@export var hero_stats:Resource
@export var projectile_stats:Resource
@export var dark_blob_stats:Resource
@export var wah_pt_stats:Resource


var alive = true
var restart_pressed=false

var knockback_is_happening=false
#@onready var projectile=$"../Projectile_enemy"
#@onready var dark_blob= $"../dark_blob"


#HERE ARE THE LEVEL VAR



var enemies: Array[CharacterBody2D]=[]

var attack_mode_on=false
var health=10
var dash_input_events
var dash_is_running=false
var dash_available=true
var attack=true
var sword_not_swinging=true
var sword_can_swing=true
var shield_is_available=true
var sheild_ongoing=false
var sheild_enabled


var dash_direction = Vector2.ZERO
var knock_direction = Vector2.ZERO
#this is to lock on the dir
var is_dashing = false 


@onready var hero =$AnimatedSprite2D
var dir="none"

var speed=130
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$sword_hit_box.monitoring=false
	$sword_hit_box/CollisionPolygon.disabled=true
	Events.sheild_enabled.connect(sheild_enabled_for_the_first_time)
	if GameData.save_data["globo_unlocked"]:
		shield_enabled()
	Events.new_map.connect(new_map)
	

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	sheild_on()
	health_gone()
	movement()
	attacked()
	#sword_swing()
	#STOP_SPAMMING()
	#dead()
	#spawn_an_enemy_1()
	#spawn_an_enemy_2()
func knockback():
	knockback_is_happening=true
	$Camera2D.screen_shake(5,0.5)
	$knockback.start()
	speed=200
	$AnimationPlayer.play("hit")
	
func movement() -> void:
	if Global.pause:
		return
 
	var direction := Input.get_vector("left", "right", "up", "down")

	if is_dashing:
		velocity = dash_direction * speed
	elif knockback_is_happening:
		velocity = knock_direction * speed
	else:
		velocity = direction * speed
 
	if not sword_not_swinging or dash_is_running:
		move_and_slide()
		return
 
	if Input.is_action_pressed("up") and Input.is_action_pressed("left"):
		dir = "lup"
		if sword_not_swinging: play_anim(1)
		dash(1)
	elif Input.is_action_pressed("up") and Input.is_action_pressed("right"):
		dir = "rup"
		if sword_not_swinging: play_anim(1)
		dash(1)
	elif Input.is_action_pressed("down") and Input.is_action_pressed("left"):
		dir = "lown"
		if sword_not_swinging: play_anim(1)
		dash(1)
	elif Input.is_action_pressed("down") and Input.is_action_pressed("right"):
		dir = "rown"
		if sword_not_swinging: play_anim(1)
		dash(1)
	elif Input.is_action_pressed("up"):
		dir = "up"
		if sword_not_swinging: play_anim(1)
		dash(1)
	elif Input.is_action_pressed("left"):
		dir = "left"
		if sword_not_swinging: play_anim(1)
		dash(1)
	elif Input.is_action_pressed("right"):
		dir = "right"
		if sword_not_swinging: play_anim(1)
		dash(1)
	elif Input.is_action_pressed("down"):
		dir = "down"
		if sword_not_swinging: play_anim(1)
		dash(1)
	else:
		if sword_not_swinging:
			play_anim(0)
			dash(0)
 
	move_and_slide()
 
 
# ---------------------------------------------------------------------------
# Animations
# ---------------------------------------------------------------------------
func play_anim(movement: int) -> void:
	match dir:
		"up":
			if movement == 1:
				$AnimatedSprite2D.flip_h = false
				$AnimatedSprite2D.play("walk_anim_back")
			else:
				$AnimatedSprite2D.play("idle_side")
		"down":
			if movement == 1:
				$AnimatedSprite2D.play("Walk_anim")
			else:
				$AnimatedSprite2D.play("idle_side")
		"left":
			if movement == 1:
				$AnimatedSprite2D.flip_h = true
				$AnimatedSprite2D.play("Walk_anim")
			else:
				$AnimatedSprite2D.play("idle_side")
		"right":
			if movement == 1:
				$AnimatedSprite2D.flip_h = false
				$AnimatedSprite2D.play("Walk_anim")
			else:
				$AnimatedSprite2D.play("idle_side")
		"lup":
			if movement == 1:
				$AnimatedSprite2D.flip_h = true
				$AnimatedSprite2D.play("walk_anim_back")
			else:
				$AnimatedSprite2D.play("idle_back_side")
		"rup":
			if movement == 1:
				$AnimatedSprite2D.flip_h = false
				$AnimatedSprite2D.play("walk_anim_back")
			else:
				$AnimatedSprite2D.play("idle_back_side")
		"lown":
			if movement == 1:
				$AnimatedSprite2D.flip_h = true
				$AnimatedSprite2D.play("Walk_anim")
			else:
				$AnimatedSprite2D.play("idle_side")
		"rown":
			if movement == 1:
				$AnimatedSprite2D.flip_h = false
				$AnimatedSprite2D.play("Walk_anim")
			else:
				$AnimatedSprite2D.play("idle_side")
func sword_swing():
	
	if Input.is_action_just_pressed("swing") and sword_can_swing:
		sword_not_swinging=false
		
		if dir=="up" or dir =="rup":
			$sword_hit_box/CollisionPolygon.set_deferred("disabled", false)
			$sword_hit_box.monitoring = true
			$AnimatedSprite2D.play("attack_anim_back")
			$AnimatedSprite2D.play("attack_anim_back")
			$sword_hit_box/CollisionPolygon/AnimationPlayer.play("collision")
			
			
		elif dir=="down" or dir =="rown" or dir == "right":
			$AnimatedSprite2D.play("attack_anim")
			$sword_hit_box/CollisionPolygon.disabled=false
			$sword_hit_box.monitoring = true
			$AnimatedSprite2D.play("attack_anim_back")
			$sword_hit_box/CollisionPolygon/AnimationPlayer.play("collision")
		elif dir=="up" or dir =="lup":
			$sword_hit_box/CollisionPolygon.disabled=false
			$sword_hit_box.monitoring = true
			$AnimatedSprite2D.play("attack_anim_back")
			$sword_hit_box/CollisionPolygon/AnimationPlayer.play("collison_left")
		elif dir=="down" or dir == "lown" or  dir == "left":
			$sword_hit_box/CollisionPolygon.disabled=false
			$sword_hit_box.monitoring = true
			$AnimatedSprite2D.play("attack_anim")
			$sword_hit_box/CollisionPolygon/AnimationPlayer.play("collison_left")
		sword_can_swing=false

		$sword_cooldown.start()
		
func dash(movement):
	if movement == 1 and dash_available:
		if Input.is_action_just_pressed("dash"):
			# 1. Capture the current movement vector
			var input_dir = Input.get_vector("left", "right", "up", "down")
			
			# 2. Only dash if we are actually moving
			if input_dir != Vector2.ZERO:
				dash_direction = input_dir.normalized()
				is_dashing = true
				dash_is_running = true
				
				$AnimatedSprite2D.visible=true
				if dir=="right":
					$AnimatedSprite2D.flip_h=false
					$AnimatedSprite2D.play("dash")
					
				elif dir =="left":
					$AnimatedSprite2D.flip_h=true
					$AnimatedSprite2D.play("dash")
				elif dir=="down":
					$AnimatedSprite2D.play("dash")
				elif dir=="up":
					$AnimatedSprite2D.play("dash")
				elif dir=="rup":
					$AnimatedSprite2D.flip_h=false
					$AnimatedSprite2D.play("dash")
				elif dir=="lup":
					$AnimatedSprite2D.flip_h=true
					$AnimatedSprite2D.play("dash")
				elif dir=="rown":
					$AnimatedSprite2D.flip_h=false
					$AnimatedSprite2D.play("dash")
				elif dir=="lown":
					$AnimatedSprite2D.flip_h=true
					$AnimatedSprite2D.play("dash")
				speed=400
				$dash_timer.start()
				$dash_cooldown.start()
				$dash_cooldown_countdown.start()
	
			

func _on_dash_timer_timeout() -> void:
	speed = 130
	is_dashing = false # This allows arrow keys to take control again
	dash_available = false
	dash_is_running = false
	$"../CanvasLayer/dash_cooldown".value=0.0
	
	


func _on_dash_cooldown_timeout() -> void:
	dash_available=true
	
	
	

#func STOP_SPAMMING():
	#var spacebar = InputEventKey.new()
	#spacebar.physical_keycode = KEY_SPACE
	#if stop_spamming:
		#InputMap.action_erase_events("dash")
	#else:
		#InputMap.action_add_event("dash", spacebar)
		
		
		
		



	





func _on_hit_box_body_entered(body: CharacterBody2D) -> void:
	if body is DarkBlob:
		body.attack=true
	elif body is ProjectileEnemy:
		body.attack=true
	elif body is WahPtFire:
		body.attack=true 
	elif body is DamianWayne:
		body.attack=true 
		
		
		
	

func _on_attack_cooldown_timeout() -> void:
	attack_mode_on=true
	
func attacked():
	if Global.pause:
		return
	for enemy in EnemyManager.enemies:
		if is_instance_valid(enemy) and enemy.attack and not sheild_ongoing:
				if attack_mode_on:
					enemy.damage()
					knock_direction=(global_position - enemy.global_position).normalized()
					knockback()
					attack_mode_on=false
					$attack_cooldown.start()
					health_bar_update()
					return false
				else:
					return true






func _on_hit_box_body_exited(body: CharacterBody2D) -> void:
	if body is DarkBlob:
		body.attack=false
	elif body is ProjectileEnemy:
		body.attack=false
	elif body is WahPtFire:
		body.attack=false
	elif body is DamianWayne:
		body.attack=false
	
func health_gone():
	if hero_stats.health<=0 and alive:
		alive=false
		#dead()
	
		

func health_bar_update():
	$"../CanvasLayer/TextureProgressBar".value=hero_stats.health

#spawner stuff
func spawn_an_enemy_1():
	if Global.pause:
		return
	if spawn_enemy_1 and Global.tutorial==false:

		var random_pos = Vector2(
			randf_range(658,1653),
			randf_range(-234,234)
		)
		var enemy_generator = randi() % 100 + 1
		if enemy_generator<=50:
			spawn_enemy_1=false
			var DB= DB_package.instantiate()
			DB.position=random_pos
			DB.hero=self
			get_tree().current_scene.add_child(DB)
			enemies.append(DB)
		elif enemy_generator>=51 and enemy_generator<=75:
			
			spawn_enemy_1=false
			var WP= WP_package.instantiate()
			WP.position=random_pos
			WP.hero=self
			get_tree().current_scene.add_child(WP)
			enemies.append(WP)
		elif enemy_generator>=76: 
			spawn_enemy_1=false
			var DW= DW_package.instantiate()
			DW.position=random_pos
			DW.hero=self
			get_tree().current_scene.add_child(DW)
			enemies.append(DW)
		

			
func _on_spawner_timer_timeout() -> void:
	spawn_enemy_1=true

func spawn_an_enemy_2():
	if Global.pause:
		return
	if spawn_enemy_2 and Global.tutorial==false:

		var random_pos = Vector2(
			randf_range(658,1653),
			randf_range(-234,234)
		)
		var enemy_generator = randi() % 100 + 1
		if enemy_generator<=50:
			spawn_enemy_1=false
			var DB= DB_package.instantiate()
			DB.position=random_pos
			DB.hero=self
			get_tree().current_scene.add_child(DB)
			enemies.append(DB)
		elif enemy_generator>=51 and enemy_generator<=75: 
			spawn_enemy_1=false
			var WP= WP_package.instantiate()
			WP.position=random_pos
			WP.hero=self
			get_tree().current_scene.add_child(WP)
			enemies.append(WP)
		elif enemy_generator>=76: 
			spawn_enemy_1=false
			var DW= DW_package.instantiate()
			DW.position=random_pos
			DW.hero=self
			get_tree().current_scene.add_child(DW)
			enemies.append(DW)

func _on_spawner_timer_2_timeout() -> void:
	spawn_enemy_2=true


func _on_sword_cooldown_timeout() -> void:
	sword_can_swing=true
	sword_not_swinging=true
	$sword_hit_box.monitoring=false
	$sword_hit_box/CollisionPolygon.disabled=true


func _on_dash_cooldown_countdown_timeout() -> void:
	if $"../CanvasLayer/dash_cooldown".value==0:
		$"../CanvasLayer/dash_cooldown".value+=3
		$dash_cooldown_countdown.start()
	elif $"../CanvasLayer/dash_cooldown".value==3:
		$"../CanvasLayer/dash_cooldown".value+=1
		$dash_cooldown_countdown.start()
	elif $"../CanvasLayer/dash_cooldown".value==4:
		$"../CanvasLayer/dash_cooldown".value+=1
		$dash_cooldown_countdown.start()
	
func shield_enabled():
	$"../CanvasLayer/AnimationPlayer".play("dash_unlocked")
	var tween = create_tween()
	tween.tween_property($"../CanvasLayer/globo", "modulate:a", 1.0, 1.0)
	await tween.finished
	sheild_enabled=true

func sheild_enabled_for_the_first_time():
	shield_enabled()
	
func sheild_on():
	if Input.is_action_pressed("shield") and shield_is_available and sheild_enabled and GameData.save_data["globo"]:
		$sheild.visible=true
		$sheild.play("sheild_on")
		sheild_ongoing=true
		await $sheild.animation_finished
		$sheild_radius/CollisionPolygon2D.disabled=false
		$sheild.play("sheild")
		$sheild_timer.start()
		$sheild_timer_blinking.start()
		$"../CanvasLayer/sheild_cooldown".value=0
		shield_is_available=false
		


func _on_sheild_timer_timeout() -> void:
	$sheild.visible=false
	$sheild_radius/CollisionPolygon2D.disabled=true
	$sheild_cooldown.start()
	$sheild_cooldown_count.start()
	sheild_ongoing=false


func _on_sheild_cooldown_timeout() -> void:
	shield_is_available=true


func _on_sheild_cooldown_count_timeout() -> void:
	if $"../CanvasLayer/sheild_cooldown".value==0:
		$"../CanvasLayer/sheild_cooldown".value+=12
		$sheild_cooldown_count.start()
	elif $"../CanvasLayer/sheild_cooldown".value==12:
		$"../CanvasLayer/sheild_cooldown".value+=1
		$sheild_cooldown_count.start()
	elif $"../CanvasLayer/sheild_cooldown".value==13:
		$"../CanvasLayer/sheild_cooldown".value+=1
		$sheild_cooldown_count.start()
	elif $"../CanvasLayer/sheild_cooldown".value==14:
		$"../CanvasLayer/sheild_cooldown".value+=1
		$sheild_cooldown_count.start()
	elif $"../CanvasLayer/sheild_cooldown".value==15:
		$"../CanvasLayer/sheild_cooldown".value+=1
		$sheild_cooldown_count.start()
	elif $"../CanvasLayer/sheild_cooldown".value==16:
		$"../CanvasLayer/sheild_cooldown".value+=1
		$sheild_cooldown_count.start()
	elif $"../CanvasLayer/sheild_cooldown".value==17:
		$"../CanvasLayer/sheild_cooldown".value+=1
		$sheild_cooldown_count.start()
	elif $"../CanvasLayer/sheild_cooldown".value==18:
		$"../CanvasLayer/sheild_cooldown".value+=1
		$sheild_cooldown_count.start()
	elif $"../CanvasLayer/sheild_cooldown".value==19:
		$"../CanvasLayer/sheild_cooldown".value+=1
		$sheild_cooldown_count.start()
	elif $"../CanvasLayer/sheild_cooldown".value==20:
		$"../CanvasLayer/sheild_cooldown".value+=1
		$sheild_cooldown_count.start()
	


func _on_sheild_timer_blinking_timeout() -> void:
	while sheild_ongoing:
		var tween = create_tween()
		tween.tween_property($sheild, "modulate:a", 0.5, 0.3)
		tween.tween_property($sheild, "modulate:a", 1.0, 0.3)
		await tween.finished

func new_map(limit_left,limit_right):
	$"../Scene_transition/AnimationPlayer".play("dissolve")
	await $"../Scene_transition/AnimationPlayer".animation_finished
	$Camera2D.limit_left=limit_left
	$Camera2D.limit_right=limit_right
	$"../Scene_transition/AnimationPlayer".play_backwards("dissolve")

	


func _on_knockback_timeout() -> void:
	knockback_is_happening=false
	speed=180
