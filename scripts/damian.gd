extends CharacterBody2D
class_name DamianWayne

var shine_package=preload("res://scenes/shine.tscn")
@export var basic_sword: Resource
@export var hero_stats: Resource
@export var enemy_stats: Resource


#memory for the last direction it stored
var speed=50
var you_can_now_take_health=true
var weapon_attack=false
var alive=true

signal died

var attack = false
var hero = null

var dash_cooldown = false
var alert_now=false
var is_dashing=false
var dash_direction = Vector2.ZERO
var hit_sheild=false
var  knockback_is_happening=false

func _ready() -> void:
	if hero == null:
		hero = get_tree().get_first_node_in_group("Hero")

	$AnimatedSprite2D.play("idle")

func _process(delta: float) -> void:
	lose_health()
	knockback()
	
	
	
	
	
	if dash_cooldown and $RayCast2D.is_colliding() and alert_now:
		dash_cooldown = false
		dash()
	
	if is_dashing:
		velocity=dash_direction*speed
		move_and_slide()
	else:
		dash_direction = Vector2.ZERO

	
		
	
	
	#offset()
func damage():
	hero_stats.damage(enemy_stats.dmg)

func get_hero_pos():
	if hero.global_position.x > global_position.x:
		return "right"
	elif hero.global_position.x < global_position.x:
		return "left"


func dash():
	if Global.pause:
		return
	if alive:
		speed=200
		is_dashing=true
		$CollisionShape2D.set_deferred("disabled", false)
		dash_direction = (hero.global_position - global_position).normalized()
		if hero.global_position.x > global_position.x:
			$AnimatedSprite2D.flip_h=false
			$Area2D.position=Vector2(-5,2)
			$exlamation_pt.position=Vector2(-26,-57)
			$AnimatedSprite2D.play("dash_right")
		elif hero.global_position.x < global_position.x:
			$Area2D.position=Vector2(15,2)
			$AnimatedSprite2D.flip_h=true
			$exlamation_pt.position=Vector2(-7,-57)
			$AnimatedSprite2D.play("dash_right")
			
		

		#if global_position.distance_to(hero.global_position) < 10:
		dash_cooldown=false
		$dash_timer.start()
	
	 
	



func _on_dash_cooldown_timeout() -> void:
	dash_cooldown = true
	pass
	


func _on_dash_timer_timeout() -> void:
	$AnimatedSprite2D.play("idle")
	$dash_cooldown.start()
	is_dashing=false
	$CollisionShape2D.set_deferred("disabled", true)
	
func lose_health():
	if alive: 
		if you_can_now_take_health:
			if weapon_attack:
				enemy_stats.damage(basic_sword.dmg)
			
			#this is so it doesnt deal crazy damage in one go
				$Attack_timer.start()
				you_can_now_take_health=false
				
				dead()




func dead():
	if enemy_stats.health <= 0:
		emit_signal("died")
		$exlamation_pt.visible=false
		$CPUParticles2D2.emitting = true
		$AnimatedSprite2D.visible=false
		$CollisionShape2D.set_deferred("disabled", true)
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
		alive=false
		if not $death_timer.is_stopped():
			return  # already started
		$death_timer.start()
		
	


func _on_attack_timer_timeout() -> void:
	you_can_now_take_health=true
	



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("sword") and alive:
		var camera= hero.get_node("Camera2D")
		camera.screen_shake(3,0.5)
		weapon_attack=true
		lose_health()
		$AnimatedSprite2D.modulate=Color(5, 5, 5)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("sword"):
		weapon_attack=false
		$AnimatedSprite2D.modulate=Color(1,1,1)


func _on_death_timer_timeout() -> void:
	call_deferred("queue_free")

func alert():
	alert_now=true


func _on_alert_body_entered(body: Node2D) -> void:
	if body.is_in_group("Hero"):
		$exlamation_pt.visible=true
		$alert_timer.start()
			


func _on_alert_body_exited(body: Node2D) -> void:
	if body.is_in_group("Hero"):
		$alert_timer.stop()
		$exlamation_pt.value=0
		$exlamation_pt.visible=false
		if $exlamation_pt.value==0:
			alert_now=false


func _on_alert_timer_timeout() -> void:
	$exlamation_pt.value+=1
	if $exlamation_pt.value==3:
		alert()
	elif $exlamation_pt.value==0:
		alert_now=false

func hit_a_wall():
	is_dashing=false
	

func _on_protector_body_entered(body: Node2D) -> void:
	if body.is_in_group("wall"):
		hit_a_wall()





func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("sheild"):
		if hit_sheild:
			return
		hit_sheild=true
		
		if is_dashing and not knockback_is_happening and hit_sheild:
			knockback_is_happening = true
			$knockback_timer.start()
			dash_cooldown=false
			var normal = (global_position - area.global_position).normalized()
			dash_direction = dash_direction.bounce(normal)
			global_position += normal * 5
			speed = 300
			$AnimatedSprite2D.modulate = Color(5,5,5)


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("sheild"):
		hit_sheild=false
		
func knockback():
	if not knockback_is_happening:
		velocity=dash_direction*speed
		speed=200
		if not weapon_attack:
			$AnimatedSprite2D.modulate = Color(1, 1, 1) 
				

				


func _on_knockback_timer_timeout() -> void:
	knockback_is_happening=false
	hit_sheild = false
