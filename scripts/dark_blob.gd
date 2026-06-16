extends CharacterBody2D
class_name DarkBlob


#explosion
@onready var explosion_package=preload("res://scenes/explosion.tscn")

@onready var shine_package=preload("res://scenes/shine.tscn")


var alive=true
var speed=50
var weapon_attack=false
var you_can_now_take_health=true

var hero:CharacterBody2D=null

var knockback_is_happening=false

@export var basic_sword: Resource
@export var hero_stats:Resource
@export var enemy_stats : Resource
var attack=false
var hit_sheild=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if hero == null:
		hero = get_tree().get_first_node_in_group("Hero")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	

	movement(delta)

	

func damage():
	hero_stats.damage(enemy_stats.dmg)
		
		
		

func lose_health():
	if alive: 
		if you_can_now_take_health:
			if weapon_attack:
				enemy_stats.damage(basic_sword.dmg)
				$timescale.start()
			#this is so it doesnt deal crazy damage in one go
				$Attack_timer.start()
				you_can_now_take_health=false
				dead()



func dead():
	if enemy_stats.health <= 0:
		var shine = shine_package.instantiate()
		shine.position=position
		get_parent().add_child(shine)
		shine.call_deferred("spawn")
	
		
		$CPUParticles2D2.emitting = true
		$AnimatedSprite2D.visible=false
		$CollisionShape2D2.set_deferred("disabled", true)
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
		alive=false
		if not $death_timer.is_stopped():
			return  # already started
		$death_timer.start()
		
		
func movement(delta: float)-> void:
	if Global.pause:
		return
	if hero == null:
		return
	var player_position=hero.global_position

	var player_velocity=hero.velocity 
	var predicted_time=0.3
	var predicted_position=player_position+player_velocity*predicted_time
	var direction= (predicted_position-position).normalized()
	if knockback_is_happening==false:
		velocity=direction*speed
		$AnimatedSprite2D.modulate = Color(1, 1, 1) 
		speed=50
	
	
	#knockback
	
	if weapon_attack or hit_sheild and not knockback_is_happening:
		knockback_is_happening = true
		$knockback_timer.start()
		speed = 250
		velocity = -direction * speed
		if knockback_is_happening:
			speed=250
			$AnimatedSprite2D.modulate=Color(255, 255, 255)
			velocity=direction*-speed
			
		
		
	for other_enemy in get_parent().get_children():
		if other_enemy==self:
			continue
		if other_enemy.is_in_group("enemies"):
			var dist=position.distance_to(other_enemy.position)
			if dist <32:
				
				var push=(position-other_enemy.position).normalized()
				velocity+=push*30
		
	move_and_collide(velocity * delta)
	
	if direction.x>0:
		$AnimatedSprite2D.flip_h=true
	else:
		$AnimatedSprite2D.flip_h=false
			







func _on_attack_timer_timeout() -> void:
	Engine.time_scale=1
	you_can_now_take_health=true
	





func _on_death_timer_timeout() -> void:
	call_deferred("queue_free")


func _on_knockback_timer_timeout() -> void:
	knockback_is_happening=false
	
	


#func _on_area_2d_area_entered(area: Area2D) -> void:
	#print("attack")
	#if area.is_in_group("sword"):
		#weapon_attack=true
		#print("attack")
		#lose_health()


#func _on_area_2d_area_exited(area: Area2D) -> void:
	#if area.is_in_group("sword"):
		#weapon_attack=false


func _on_area_2d_body_entered(body: RigidBody2D) -> void:
	if alive:
		if body.is_in_group("sword"):
			weapon_attack=true
			var camera= hero.get_node("Camera2D")
			camera.screen_shake(3,0.5)
			lose_health()


func _on_area_2d_body_exited(body: RigidBody2D) -> void:
	if body.is_in_group("sword"):
		weapon_attack=false
		



func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("sheild"):
		hit_sheild=true


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("sheild"):
		hit_sheild=false
