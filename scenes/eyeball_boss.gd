extends CharacterBody2D


@export var bullet_package=preload("res://scenes/eyeball_bullet.tscn")
@export var hero_stats: Resource
@export var enemy_stats: Resource
@export var basic_gun: Resource

var health=60
var hero=null
var alive=true
var you_can_now_take_health=true
var weapon_attack=false
var in_hitbox=false

var should_sheild_be_down=true
var sheild_up=true
var BULLET_SPEED=2
var formation=0
var random_ray=0

#this is for formation 2
var minus=0
var can_eyeball_hit_now=false

var boss_phase = 1

signal died

func _ready() -> void:
	print(health)
	$bullet_timer.start()
	$monster/shield_collison/CollisionShape2D.disabled=false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_bullet_timer_timeout() -> void:
	spawn_bullet()

	
	
func bullet_spawn_formation_2_gradual_through_left(rays):
	random_ray = (rays.size() - 1) - minus
	minus += 1
	
	#if minus >= rays.size():
		#minus = 0
		

		
func bullet_spawn_formation_1_gradual_through_right(rays):
	random_ray += 1

	#if random_ray >= rays.size():
		#random_ray = 0

func bullet_spawn_formation_3_burst(rays):#doent work
	for i in range(rays.size()):
		random_ray += 1

func disban_sheild():
	if boss_phase == 1 and Global.eyeball_hit_counter>=21:
		sheild_up=false
		boss_phase = 2
		$monster/sheild/AnimationPlayer.play("shield_disban")
		$monster/shield_collison/CollisionShape2D.set_deferred("disabled", true)
	elif boss_phase == 3 and Global.eyeball_hit_counter >= 42:
		sheild_up=false
		boss_phase = 4
		$monster/sheild/AnimationPlayer.play("shield_disban")
		$monster/shield_collison/CollisionShape2D.set_deferred("disabled", true)

	
func spawn_bullet():
	#20=5
	if Global.eyeball_hit_counter<=20 or sheild_up:
		var bullet = bullet_package.instantiate()
		var rays = $ray_cast.get_children()
		var ray = rays[random_ray]
		
		if formation==0:
			if random_ray<rays.size():
				bullet_spawn_formation_1_gradual_through_right(rays)
			if random_ray>=rays.size():
				formation+=1
				random_ray=0
		elif formation==1 or 2:
			if minus<rays.size():
				bullet_spawn_formation_2_gradual_through_left(rays)
			if minus>=rays.size():
				formation+=1
				minus=0
				random_ray=0
		if formation==3:
			if random_ray<rays.size():
				bullet_spawn_formation_1_gradual_through_right(rays)
			if random_ray>=rays.size():
				formation=0
				random_ray=0
			
		
			
		

		get_tree().current_scene.add_child(bullet)
		EnemyManager.bosses.append(bullet)
		bullet.speed=BULLET_SPEED
		bullet.global_position = ray.global_position
		bullet.direction = ray.target_position.normalized()
	


func reenact_sheild():
	if boss_phase==2 and health<=30:
		boss_phase=3
		sheild_up=true
		$monster/sheild/AnimationPlayer.play_backwards("shield_disban")
		$monster/shield_collison/CollisionShape2D.set_deferred("disabled", false)
		BULLET_SPEED=4
	

		

func _on_shield_collison_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies") or body.is_in_group("boss"):
		Global.eyeball_hit_counter+=1
		Events.emit_signal("eyeball_bullet_hit_eyeball")
		disban_sheild()
	
		
		
		

func lose_health():
	if you_can_now_take_health:
		if weapon_attack:
			health=(health-basic_gun.dmg)
			#this is so it doesnt deal crazy damage in one go
			$attack_timer.start()
			you_can_now_take_health=false
			dead()



func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("gun"):
		#var camera = hero.get_node("Camera2D")
		#camera.screen_shake(3,0.5)
		weapon_attack=true
		lose_health()
		$monster.modulate=Color(5, 5, 5)
		reenact_sheild()
		

func _on_hit_box_body_exited(body: Node2D) -> void:
	if body.is_in_group("gun"):
		weapon_attack=false
		$monster.modulate=Color(1, 1, 1) 




		
func dead():
	if health <= 0:
	
		
		
		$CPUParticles2D2.emitting = true
		$monster.visible=false
		$CollisionShape2D.set_deferred("disabled", true)
		$monster/hit_box/CollisionShape2D.set_deferred("disabled", true)
		$monster/shield_collison/CollisionShape2D.set_deferred("disabled", true)
		call_deferred("_emit_died")
		if not $death_timer.is_stopped():
			return  # already started
		$death_timer.start()
		
func _emit_died():
	emit_signal("died")

func _on_death_timer_timeout() -> void:
	call_deferred("queue_free")


func _on_attack_timer_timeout() -> void:
	you_can_now_take_health=true
